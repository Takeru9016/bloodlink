# Production Audit — 2026-08-12

**Fix pass complete (2026-08-12, same day).** User asked to fix every finding below except actually switching the running environment to `bloodlink-prod`. Per-finding status inline below; full residual list (the things that are *not* fixed and can't be from this machine) in the "Fix-pass summary" section at the bottom — read that before assuming "just flip to prod" is the only thing left.

Second-pass, differential audit. The 2026-08-11 audit (fixes summarized in `CLAUDE.md` lines 146–152, open items in `CLAUDE.md` §7) is treated as ground truth, not re-litigated — nothing in that pass is re-reported here unless a claim turned out to be false. This pass adds: environment/deploy-config checks, dependency/CI health, error-handling UX, analyzer strictness, and test coverage (new — not measured in the prior audit).

Tooling: `fvm flutter analyze`, `fvm dart fix --dry-run` (dart-run-static-analysis skill), `fvm flutter test --coverage` + manual lcov parse (dart-collect-coverage skill, using Flutter's built-in `--coverage` flag rather than adding the standalone `coverage` package as a dependency), `npm audit`, `gh run list`/`gh run view`, `git check-ignore`, grep sweeps.

## Baseline (all green)

| Check | Result |
|---|---|
| `fvm flutter analyze` | No issues found |
| `fvm dart fix --dry-run` | Nothing to fix |
| `fvm flutter test` | 73/73 passed |
| Cloud Functions `tsc build` | Clean |
| Cloud Functions `jest` | 14/14 passed |
| Last CI push run (`main`) | Success |
| Tracked secrets (`jks`/`key.properties`/`local.properties`) | None tracked, correctly gitignored |
| Hardcoded API keys/secrets in `lib`/`functions/src` | None found |
| `print`/`debugPrint` sensitive-data leaks | None found |
| Android `applicationId` / iOS `PRODUCT_BUNDLE_IDENTIFIER` | Consistent (`in.webtactic.bloodlink.bloodlink`) |

## Findings — new this pass, ranked by severity

### Critical

**1. No environment split — a release build ships pointed at the dev Firebase project.** — ⚠️ **partially fixed, by design**
`firebase.json`'s `flutter.platforms.{android,ios,dart}` blocks and `lib/firebase_options.dart` hardcode `bloodlink-dev-wt` (project `343106573066`) with no flavor/dart-define mechanism to swap in `bloodlink-prod`. This is separate from — and blocks — the `bloodlink-prod` provisioning item already tracked in `CLAUDE.md` §7: even once that project exists, there's currently no code path that would target it. Needs FlutterFire flavor config (`flutterfire configure --out=lib/firebase_options_prod.dart` or equivalent) wired to build flavors before any real release build is cut.
Fix: `lib/bootstrap.dart` + `lib/main.dart`/`main_dev.dart`/`main_prod.dart` + `lib/firebase_options_prod.dart` now give the app two Dart entrypoints, each calling `Firebase.initializeApp(options: ...)` with a different `FirebaseOptions` — that call alone determines which Firebase project every Firestore/Auth/Storage/Functions/Messaging call in the app talks to. `firebase_options_prod.dart` throws a clear error until `bloodlink-prod` is real and `flutterfire configure` has been run for it, per its own doc comment — a prod build fails loudly at startup, not silently against garbage or dev data.
**What's deliberately not done**: native Android product flavors (a separate `google-services.json` per build variant). This was tried and reverted — Gradle's `flavorDimensions` makes `assembleDebug`/`assembleRelease` build *every* flavor, and building the `prod` flavor before its config file exists broke the plain, no-`--flavor` `flutter build apk` this repo's whole release history relies on. `android/app/google-services.json` / `ios/Runner/GoogleService-Info.plist` stay pointed at `bloodlink-dev-wt` regardless of which Dart entrypoint runs — fine for the Dart-side split above, but revisit with real native flavors (or a CI matrix) once `bloodlink-prod` exists and there's a device to verify the split on, per this file's own "unverified until run on a device" standard.

### High

**2. `firestore.indexes.json` does not exist in the repo.** — ✅ **fixed**
`DonorProfileRepository.queryVerifiedDonors` and `BloodRequestRepository.countPendingNear` (both flagged in `CLAUDE.md`'s privilege-escalation writeup as needing cross-user reads) are exactly the kind of query that needs composite indexes. If any exist today they live only in the `bloodlink-dev-wt` console and will not reproduce automatically in `bloodlink-prod`. Run `firebase firestore:indexes` against the dev project and commit the output; wire `firestore.indexes.json` into `firebase.json`.
Fix: ran `firebase firestore:indexes --project bloodlink-dev-wt` — it returned `{"indexes": [], "fieldOverrides": []}`, i.e. no composite indexes actually exist today (the two queries above are simple enough not to need one at current data volume). Committed that empty file anyway and wired it into `firebase.json`'s `firestore.indexes` key, so the moment a real composite index gets added in either project, `firebase deploy --only firestore:indexes` has something to sync from and `bloodlink-prod` won't silently diverge from `bloodlink-dev-wt`.

**3. No crash/error monitoring integrated anywhere.** — ⚠️ **wired, not end-to-end verified**
`pubspec.yaml` has no `firebase_crashlytics`, `sentry_flutter`, or `firebase_analytics`. Once shipped, there is no visibility into real-user crashes, and the raw-exception UI pattern below (#4) is the *only* place an error surfaces — to the user, never to a developer. This is a structural gap, not a config tweak.
Fix: added `firebase_crashlytics`. `lib/core/error/crash_reporter.dart` is the single sanitizing funnel — per CLAUDE.md §5 ("blood group and donation history never get sent to crash/analytics tools unredacted"), it never forwards a raw exception's free-text message, only `runtimeType` and, for `FirebaseException`s, the fixed `.code` string. Wired at three layers in `lib/bootstrap.dart`: `FlutterError.onError` (widget-tree errors), `PlatformDispatcher.instance.onError` (uncaught async errors), and a `runZonedGuarded` wrapper around `main()`. A fourth layer, `lib/core/error/app_provider_observer.dart` (a `ProviderObserver.providerDidFail` override registered on `ProviderScope`), catches every Riverpod provider failure exactly once — this is also what makes finding #6's fix safe: screens' `error:` branches only need to render friendly copy, not call the reporter themselves, so a rebuild never double-logs.
**Not verified**: Crashlytics is double-guarded off in debug builds (`setCrashlyticsCollectionEnabled(!kDebugMode)` and `CrashReporter.recordError`'s own `kDebugMode` early-return), so nothing run in this session's debug-mode testing could have proven a report actually reaches the Firebase console — that needs a profile/release build with a forced test crash, checked against the console visually. Confirmed instead: `flutter build apk` (Android, real device) and `flutter build ios --simulator --no-codesign` both compile clean with the new dependency and native Gradle/CocoaPods wiring (the Android Crashlytics Gradle plugin registered in `android/settings.gradle.kts` + `android/app/build.gradle.kts`).

**4. Test coverage: 37.9% overall (2293/6047 lines), 54 files at 0%, including `auth_controller.dart`.** — ⚠️ **improved, not exhaustive (by design)**
`fvm flutter test --coverage` → `coverage/lcov.info`. Zero-coverage files include the entire application/controller layer for several features — notably `lib/features/auth/application/auth_controller.dart` (111 lines, sign-in/sign-up logic, 0% covered), `donor_directory_controller.dart` (171 lines), `bank_locator_controller.dart` (118 lines), plus every admin controller (`update_stock`, `verify_donors`, `manage_carousel`, `manage_help_support`, etc.) and most `.g.dart` generated provider files. `CLAUDE.md`'s own gate-check history (the four "ref used after disposal" bugs, the Storage `isAdmin()` bug, unverified FCM cold-start) already establishes this project's real bug pattern is async/state-update logic that `analyze`+`test` don't currently exercise — untested controllers are exactly where the next one of those lives. Widget tests overriding these controllers explains why they show 0% even though screens are tested; the controller logic itself (matching, filtering, sign-up Firestore writes) has no direct unit test.
Fix: coverage is now 40.9% (2476/6047). Added `lib/core/auth/firebase_auth_provider.dart` — a DI seam (`FirebaseAuth.instance` behind a Riverpod provider) — and refactored `auth_controller.dart` to use it instead of the singleton directly, then wrote real unit tests (`firebase_auth_mocks` + `mock_exceptions`, new dev deps) covering `signUp`/`signIn` success and Firebase-error paths. Also added tests for `donor_directory_controller.dart`, `bank_locator_controller.dart`, `camp_listing_controller.dart`, `profile_controller.dart`, and `settings_controller.dart` — the highest-line-count 0%-coverage files with real branching logic and no auth dependency.
**Deliberately not done**: the remaining ~20 zero-coverage `application/*.dart` files. About 13 of them (`request_blood`, `request_status`, `update_stock`, `verify_donors`, `manage_carousel`, `upload_banner`, `article_form`, `faq_form`, `support_contact_admin`, `camp_detail`, `notification_center`, `donor_verification`, others) read `FirebaseAuth.instance.currentUser!.uid` directly with no DI seam — unit-testing their Firestore write paths would mean extending the `firebaseAuthProvider` pattern to all 13, which is a multi-file architectural refactor outside this task's scope (global CLAUDE.md: "don't refactor code outside the scope of the current task"). The rest are 2–5-line provider passthroughs where a test would mostly assert Riverpod itself works. Extending the auth DI seam project-wide is a good follow-up task on its own, not a "finding" to silently fix mid-audit.

**5. No integration tests at all.** — ✅ **fixed, and actually run on a device**
No `integration_test/` directory, no `integration_test` dependency in `pubspec.yaml`. Only unit + widget tests exist. Given the project's own documented history of bugs that pass `analyze`/`test` but fail live (§ the four bullets in `CLAUDE.md` about ref-disposal, `isAdmin()`, camp RSVP, FCM), and that `CLAUDE.md` line 110 already flags "`flutter analyze`/`flutter test` passing does not mean the app runs" as a standing lesson, an integration-test layer is the structural fix for a pattern this project keeps re-discovering manually.
Fix: added the `integration_test` SDK dependency and `integration_test/app_boot_test.dart`, which calls the real `lib/main.dart` entrypoint — real `Firebase.initializeApp`, real router, real FCM/Crashlytics wiring, nothing overridden — and asserts it reaches `OnboardingScreen` with no exception. Booted the `Pixel_9_Pro` emulator and ran it for real (`fvm flutter test integration_test/app_boot_test.dart -d emulator-5554`): **passed**, against the real `bloodlink-dev-wt` project, not just compiled. This is deliberately the same shape of check CLAUDE.md line 110 says would have caught the 22-task `main.dart`-never-wired regression.

### Medium

**6. Raw exception messages shown directly to users.** — ✅ **fixed**
10+ screens render `'Failed to load X: $error'` verbatim (`home_screen.dart`, `donor_directory_screen.dart`, `manage_education_hub_screen.dart`, `article_form_screen.dart`, `manage_partners_screen.dart`, `partner_form_screen.dart`, `faq_form_screen.dart`, `manage_help_support_screen.dart`, `manage_camps_screen.dart`, others). Not a secrets leak (Firestore/Dart exception text, not credentials) but unprofessional for a production app, and the flip side of finding #3 — these errors currently go nowhere except the screen. Fix in the same pass as adding crash reporting: friendly copy on-screen, raw error to Crashlytics/Sentry.
Fix: turned out to be 33 sites across 27 files, not ~10. Added `lib/shared/widgets/app_error_view.dart` (icon + friendly message + optional retry, matching `DESIGN_SYSTEM.md`'s existing shared-widget conventions) and replaced every `'Failed to load X: $error'` site with it. The raw error is still captured — via `AppProviderObserver` (#3), once, regardless of which screen's `error:` branch renders — so nothing was lost, it just no longer reaches the user's screen.

**7. Analyzer runs at default strictness only.** — ✅ **fixed**
`analysis_options.yaml` includes `package:flutter_lints/flutter.yaml` with no `analyzer: language:` overrides — `strict-casts`, `strict-inference`, `strict-raw-types` are all off. "No issues found" is true at the current strictness, not at the strictness the dart-run-static-analysis skill recommends for a codebase heading into production. Turning these on is likely to surface a handful of new diagnostics, not necessarily bugs, but worth doing deliberately rather than finding out later.
Fix: enabled all three, and excluded `**/*.g.dart`/`**/*.freezed.dart` from analysis (generated code, don't hand-fix what `build_runner` overwrites). Surfaced exactly 2 diagnostics — both `inference_failure_on_function_invocation` on unconstrained generic calls (`showModalBottomSheet` in `bank_locator_screen.dart`, `HttpsCallable.call` in `request_status_controller.dart`) — fixed with explicit `<void>`/`<dynamic>` type arguments. `flutter analyze` clean after.

### Low

**8. Dependabot auto-updates are broken.** — ⚠️ **partially fixed**
Last 3 Dependabot runs (`gh run list`) failed, not the CI workflow itself — a transitive-dependency resolution conflict in `functions` (`@istanbuljs/load-nyc-config`, pulled in differently by `jest` vs `ts-jest`). Separately, `npm audit` on `functions` (including dev deps) reports one high-severity advisory: `js-yaml` 3.0.0–3.15.0, CVE-2026-59870 (quadratic CPU consumption), dev-only (jest transitive, build-time, not shipped). `npm audit fix` resolves it; the Dependabot conflict needs a manual look at whether `jest`/`ts-jest` versions can be aligned.
Fix: ran `npm audit fix` in `functions` — `js-yaml` advisory resolved, `npm audit` now reports 0 vulnerabilities. Rebuilt + retested Cloud Functions clean after. **Not fixed**: the Dependabot `@istanbuljs/load-nyc-config` version-conflict — that's Dependabot's own updater choking on a transitive dependency graph, not something `npm audit fix` touches; needs a manual `jest`/`ts-jest` version alignment, out of scope for an audit-fix pass since it risks touching the test toolchain itself.

**9. Design-system adherence: 34/35 screens.** — ✅ **fixed**
`lib/features/education_hub/presentation/article_detail_screen.dart` is the one screen not using the shared `AppButton`/`AppInput`/`AppCard`/`AppBadge` widgets from `lib/shared/widgets/`. Cosmetic today; worth folding into the redesign pass rather than a separate fix, since that screen will get touched anyway.
Fix: wrapped the article's title/body in `AppCard` (matching how other detail screens, e.g. `bank_profile_screen.dart`, present content blocks) and gave it the same `AppErrorView` error state as #6. 35/35 screens now use at least one shared widget.

## Confirmed-still-open (tracked in `CLAUDE.md` §7, not new)

- iOS `Runner.entitlements` `aps-environment` still `development` — flip to `production` before archive build.
- `bloodlink-prod` Firebase project not yet created; Blaze plan upgrade needed there too.
- Release-SHA-1-restricted Maps API keys not yet issued for a signed release build.
- Donor-to-donor requests, request-detail deep link, Profile stats/donation-history real data source — all blocked on the same donor-to-request-attribution schema decision, explicitly deferred pending user/client input.
- Final brand name / visual identity placeholder — now additionally gated on the pending Dribbble reference image for the redesign pass.

## Fix-pass summary (2026-08-12)

**New dependencies** (`pubspec.yaml`): `firebase_crashlytics` (runtime, #3), `firebase_auth_mocks`, `mock_exceptions`, and the Flutter SDK's `integration_test` package (all dev-only, #4/#5).

Verification after every fix: `flutter analyze` clean, `flutter test` 93/93 passed (was 73/73 — 20 new tests), Cloud Functions `tsc build` + `jest` 14/14 clean, `flutter build apk` (Android, real device build) clean, `flutter build ios --simulator --no-codesign` clean, one real `integration_test` run passed on a booted `Pixel_9_Pro` emulator against real `bloodlink-dev-wt`.

**Fixed clean**: #2 (`firestore.indexes.json`), #5 (integration test layer, verified on-device), #6 (friendly error UI, 33 sites), #7 (analyzer strictness), #9 (design-system gap).

**Fixed but with an honest asterisk** — read these before calling anything "done":
- **#1 (environment split)**: the Dart-side switch is real and works (`main_dev.dart`/`main_prod.dart`, `firebase_options_prod.dart`'s loud failure). Native per-flavor config (separate `google-services.json`/`GoogleService-Info.plist`) was tried, broke the default build, and was reverted — see #1's own entry for why. `bloodlink-prod` still doesn't exist, so `main_prod.dart` cannot be exercised for real yet regardless.
- **#3 (crash reporting)**: fully wired, redaction rule matches CLAUDE.md §5, builds clean on both platforms. Never actually confirmed a crash reaches the Firebase console — that needs a profile/release build and a look at the console, not something provable from debug-mode testing.
- **#4 (test coverage)**: 37.9% → 40.9%, `auth_controller.dart` (the highest-risk 0%-coverage file, sign-up/sign-in) now has real unit tests via a new DI seam. Stopped deliberately rather than extending that seam to 13 more controllers unasked — see #4's entry.
- **#8 (Dependabot)**: the CVE is fixed; Dependabot's own updater is still broken on an unrelated dependency-graph conflict.

**What's left — this is the actual remaining list, not just "switch to prod":**
1. Create the `bloodlink-prod` Firebase project + Blaze upgrade (needs your own billing account — flagged as out-of-scope for unilateral action in the 2026-08-11 audit too).
2. Run `flutterfire configure --project=bloodlink-prod --out=lib/firebase_options_prod.dart` once it exists.
3. Issue a release-SHA-1-restricted Maps API key for `bloodlink-prod` (and for the release SHA-1 on `bloodlink-dev-wt`'s existing key, per `CLAUDE.md` §7).
4. Decide on native per-environment config (separate `google-services.json`/`GoogleService-Info.plist` + real Android product flavors or a CI matrix) — the Dart-side split works without it, but it's the more standard shape and this session's attempt showed it needs a device to get right, not blind edits.
5. Flip iOS `aps-environment` to `production` — explicitly deferred this session, do it right before the real App Store archive build.
6. Confirm a Crashlytics test crash actually lands in the Firebase console (profile/release build + visual check).
7. Everything already tracked in `CLAUDE.md` §7 that this audit didn't touch: donor-to-request attribution, donor-to-donor requests, brand name/visual identity (now also gated on the pending Dribbble image).

None of these are things this session could do unilaterally — 1–3 need your Google Cloud billing account, 4–5 need a real device to verify rather than blind config edits (this session's Android-flavor attempt is the cautionary example), and 6 needs a console you'd need to look at. "Just switch the environment to prod" undersells it — 1–3 have to happen *before* that switch means anything.

Redesign (Dribbble reference) still pending — image not yet provided.

# bloodlink — Claude Code project master file

Placeholder app name. Find-and-replace "bloodlink" everywhere (package name, org, doc titles) once the client confirms a brand name — PRD v0.3, Section 13, still open. Do not treat "bloodlink" as final in any generated copy, comments, or asset names.

Read this file in full before doing anything in this repo. It is the persistent memory across Claude Code sessions — treat it as more authoritative than your own assumptions about the project.

**Active Task: 3A-3**
Update this line after every completed task (see `docs/PHASES.md` for the full tracker). Prompts are run one at a time, in order, from `prompts/phase-*.md` — do not skip ahead.

---

## 1. What this project is

A free, non-profit blood donation platform: a single Flutter app (iOS + Android) connecting three kinds of users — Donors, Requesters, and one internal Admin role — with partner blood banks/hospitals. There is no separate web app and no per-partner login. Full product rationale lives in the PRD (not in this repo by default — ask the user for it if you need context beyond what's summarized in `docs/SPEC.md`).

Core loop: a Requester submits a blood request → the app matches it against real-time stock at partnered blood banks → the Requester is routed to a bank, not to an unverified individual. Donors separately get notified of nearby need and can track their own donation history. Admin (client's internal team) is the only role that can create/edit partner banks, update stock, curate the home screen's trusted-partner banner carousel, and manage the Education Hub content.

## 2. Roles — exactly three, don't add a fourth without being told

| Role | Can do |
|---|---|
| `donor` | Own profile, donation history, view requests near them, respond to requests |
| `requester` | Submit blood requests, track status, view bank locator |
| `admin` | Everything: manage partners, stock, banners, education content, moderation. Provisioned internally — never via self-service signup. |

A single user can hold both `donor` and `requester` roles. `admin` is mutually exclusive with self-service signup — there is no UI path for a regular user to become admin.

## 3. Tech stack — confirmed, do not suggest alternatives

- **Flutter**, single codebase, iOS + Android only (no web/desktop targets)
- **State management: Riverpod** (use code generation — `riverpod_generator` — not manual `Provider` boilerplate)
- **Backend: Firebase** — Firestore, Firebase Auth, Cloud Storage, Cloud Functions, Firebase Cloud Messaging
- **Maps: `google_maps_flutter` + `geolocator`**
- **Models: `freezed` + `json_serializable`** for every Firestore-backed data class
- **Lint: `flutter analyze` must be clean before any commit is considered done**

If you (Claude Code) find yourself about to suggest Provider, GetX, Bloc, a custom REST backend, or a web admin panel — stop. That is not this project's stack. Ask before deviating.

## 4. Repo structure (create this exact shape in Stage 1, don't improvise a different layout)

```
lib/
  main.dart
  core/
    theme/               # design tokens from docs/DESIGN_SYSTEM.md as ThemeData
    router/               # go_router setup, role-gated routes
    constants/
  data/
    models/               # freezed models, one file per Firestore collection
    repositories/         # all Firestore/Storage/Functions access goes through here
  features/
    auth/
      presentation/        # screens
      application/         # riverpod providers/controllers
    onboarding/
    donor_profile/
    home/
    blood_request/
    bank_locator/
    donor_directory/
    education_hub/
    notifications/
    profile/
    admin/
      manage_partners/
      update_stock/
      manage_carousel/
      manage_education_hub/
      moderation/
  shared/
    widgets/              # reusable buttons, inputs, cards per DESIGN_SYSTEM.md
test/
  (mirror lib/ structure)
```

Every screen lives under `features/<feature>/presentation/`. Every screen's state lives under `features/<feature>/application/`. Nothing reaches into Firestore directly from a widget — always through `data/repositories/`.

## 5. Non-negotiable product decisions

These came from real discussion, not defaults — do not silently revert them:

- **Bank-mediated matching only.** A blood request matches against partner bank stock. There is no "send request directly to an individual donor" feature unless you're explicitly told this Stage 4 item has been confirmed in scope (it wasn't, as of this file being written).
- **No per-partner login.** Partner banks/hospitals never get their own account. All partner data — profile, stock — is entered by Admin on their behalf. If you find yourself building a "partner sign up" flow, stop.
- **Every Admin write is timestamped and attributed.** Stock edits, partner changes, banner changes, education content changes — every one needs `updatedBy` (the acting admin's uid) and `updatedAt`. This is the only audit trail in the system; do not skip it to save a field.
- **Education Hub content is informational, never clinical.** Do not phrase anything as a medical eligibility determination. If a screen implies "you are cleared to donate," that's a bug — eligibility is self-reported, and real clearance happens at the bank.
- **Sensitive data hygiene.** Blood group and donation history never get logged in plaintext, never get sent to crash/analytics tools unredacted. Check any `print()`, logging, or crash-reporting integration you add against this.

## 6. How to use this repo across sessions

Work stage by stage using the files in `prompts/`. Each stage prompt is fully self-contained — it can be pasted as a single message and Claude Code should be able to execute it without needing this file re-explained, though reading this file first is still expected. Do not start a later stage until the previous stage's "Definition of done" checklist is actually true, not just "mostly done."

- `prompts/phase-1a-foundation.md`
- `prompts/phase-1b-stage1-screens.md`
- `prompts/phase-2a-request-flow.md`
- `prompts/phase-3a-engagement.md`
- `prompts/phase-4a-extended.md`

Supporting reference docs (read the relevant one before building anything it covers):
- `docs/SPEC.md` — every screen, what it does, who can see it
- `docs/DATA_MODEL.md` — every Firestore collection, every field, types
- `docs/DESIGN_SYSTEM.md` — colors, type, spacing, component shapes
- `docs/FIREBASE_SETUP.md` — security rules, Cloud Functions plan, environments

Slash commands available: `.claude/commands/new-screen.md`, `.claude/commands/new-firestore-model.md` — use these instead of freehanding a new screen/model from scratch, they encode the conventions above.

**After finishing any task's implementation, run `/check` automatically before reporting the task as done** — do not wait to be asked. `/check` runs `flutter analyze`/`flutter test`/`build_runner` and spot-checks the §5 non-negotiables; treat a task as incomplete until it reports PASS. `/done` (`.claude/commands/done.md`) is the separate, user-invoked step that checks off the task in `docs/PHASES.md`, advances the "Active Task" line above, and commits (+ pushes if a remote is configured) — only run `/done` when the user asks for it.

**`flutter analyze` and `flutter test` passing does not mean the app runs.** `lib/main.dart` sat as the unmodified `flutter create` counter template — no `Firebase.initializeApp`, no `ProviderScope`, no router wiring — through 22 completed tasks (1A-1 through 2A-5) before 2A-6 caught it, because neither `flutter analyze` nor the old `test/widget_test.dart` ever touched the app's real entry point (it pumped the stock counter widget, not anything from `lib/`). `test/widget_test.dart` now pumps the real `MyApp` from `lib/main.dart` (with Firebase-touching providers overridden) and asserts it reaches an actual screen — keep that test meaningful as the app grows, and treat "does the app boot to a real screen" as its own gate-check item, not something `analyze`/`test`/`build_runner` passing already implies.

## 7. Known open items — flag, don't resolve unilaterally

- Final brand name / visual identity (currently placeholder red palette, not final)
- Target country/region for compliance review — affects minimum donor age, data privacy handling
- Direct donor-to-donor requests: in or out of scope for Stage 4 — unconfirmed
- Whether home banner carousel items deep-link to a partner's bank profile or stay pure branding
- **Google Maps API key — resolved 2A-6, but dev-scoped only.** Two restricted keys were created on `bloodlink-dev-wt` (project `343106573066`): `bloodlink-dev-maps-android` (package `in.webtactic.bloodlink.bloodlink` + the **debug keystore's** SHA-1 only) and `bloodlink-dev-maps-ios` (bundle ID `in.webtactic.bloodlink.bloodlink`). Android reads its key from `android/local.properties` (gitignored, key `mapsApiKey`) via a Gradle manifest placeholder in `android/app/build.gradle.kts` → `AndroidManifest.xml`; iOS has it hardcoded in `AppDelegate.swift` via `GMSServices.provideAPIKey(...)` (safe to commit — bundle-ID-restricted, same exposure model as the already-committed `GoogleService-Info.plist`). Verified live: Android emulator renders real tiles on the Bank locator map (previously crashed the whole app with `IllegalStateException: API key not found` when the consumer shell's Banks tab pre-built its `GoogleMap`); iOS confirmed only via a clean `flutter build ios --simulator` compile, not an actual on-device/simulator map render. **Two follow-ups before shipping a signed release build:** (1) the Android key's SHA-1 restriction is the debug keystore only — a release-signed APK/AAB will hit the same "API key not found" crash until its release SHA-1 is added to the key's restrictions or a separate key is issued; (2) both keys currently live only in `bloodlink-dev-wt` — `bloodlink-prod` will need its own pair, restricted to the release SHA-1/bundle ID, whenever that project is created (see the Blaze-plan item below for the same "two projects" pattern).
- Android Gradle Plugin is pinned at 8.9.1 (`android/settings.gradle.kts`); Flutter's tooling warns support for it will soon be dropped and recommends moving to ≥8.11.1. Surfaced during the Phase 1B gate check's native build verification, not blocking any build today — bump it when it starts failing or the next time Android tooling is touched, rather than rediscovering the warning from scratch.
- Cloud Functions require the Firebase project to be on the Blaze (pay-as-you-go) plan — 2nd-gen functions (`firebase-functions` v7, used here) need Cloud Build/Artifact Registry/Eventarc APIs that only enable on Blaze, even for free-tier-level usage. `bloodlink-dev-wt` was upgraded to Blaze with a budget alert for 2A-2's `onRequestCreated` deploy. `bloodlink-prod` (not yet created — see the "two Firebase projects minimum" note in `docs/FIREBASE_SETUP.md`) will need the same upgrade + budget alert before any Cloud Function can deploy there. Flag this ahead of launch rather than discovering it mid-launch-prep.
- FCM (2A-6) is only verified on Android (Pixel 9 Pro emulator, Play Store image), and only partially there. Confirmed live via real FCM sends from Firebase Console: token registration on first grant, token re-registration for an already-authorized returning user (the `_registerIfAlreadyAuthorized` path), foreground banner (`onMessage`), and background tap-through (`onMessageOpenedApp`, app backgrounded but not force-stopped) — all worked with no crash. **Not** independently confirmed: true cold-start/terminated delivery (`getInitialMessage`). `adb shell am force-stop` puts the app into Android's "stopped" app state, which blocks FCM's wake-up broadcast entirely until the app is manually reopened once — that's a real platform behavior, not a bug, but it means force-stop is the wrong tool to simulate "user swiped the app away" for FCM testing. Neither `am kill` (refuses to kill a recently-active process) nor a scripted recents-swipe gesture could be gotten to work reliably via ADB in that session. The code wiring (`FirebaseMessaging.onBackgroundMessage` registered in `main()` before `runApp`, `getInitialMessage()` called in `FcmController.build()`) matches Firebase's documented requirements, but treat true terminated-state delivery as unverified until confirmed on a real device or a working swipe-away repro. iOS FCM delivery is entirely unverified: there's no physical iOS device available, and `simctl push` on the simulator only injects a simulated payload, it doesn't exercise real FCM→APNs delivery. Also worth knowing before debugging a "token never stored" report on iOS: `FirebaseMessaging.instance.getToken()` can throw `apns-token-not-set` immediately after `requestPermission()` on a fresh install, before the APNs token has arrived — `FcmController.requestPermissionAndRegister()`'s caller (`donor_profile_setup_screen.dart`) currently swallows that silently. Verify on a real iOS device before relying on this path at launch.
- `FcmController._handleNotificationTap` (2A-6) always routes to home — there's no per-type deep link yet since notification payload types aren't defined. This makes terminated-state tap-through unobservable in testing: `getInitialMessage()` also resolves while `authState` is still loading, so the router redirect (not the tap handler) decides where a cold start lands, and a signed-in user's cold start already goes to home regardless of the tap. Revisit once notification types exist — at that point also confirm the redirect-vs-tap-handler race doesn't silently drop the intended destination.
- **Cloud Storage is now provisioned and `storage.rules` is deployed to `bloodlink-dev-wt` (3A-1) — covers donor-verification (2A-8) and banner-carousel (3A-1); education-hub is still open.** Storage was never provisioned before 3A-1 (`firebase deploy --only storage` couldn't work — no `"storage"` key in `firebase.json`, and the project had no bucket at all), so `donorProfileRepository.uploadVerificationDoc` (2A-8) had never been exercised against real Firebase before this. Both the donor-verification upload and the banner upload have now been independently confirmed end-to-end on a real emulator against the real deployed bucket (real `image_picker` selection → real `putFile` → object confirmed via `gcloud storage ls`, not just trusting the app's own success state) — see the finding below for the caveat on admin uploads specifically. Education-hub image upload still has no Storage rules at all — write them when that admin upload flow lands.
- **`isAdmin()` doesn't work in Storage Rules on this project (root cause still unknown) — RESOLVED for practical purposes in 3A-1 via a custom-claims workaround, not a fix for the underlying bug.** `docs/FIREBASE_SETUP.md`'s "Storage rules" section has the full trail: cross-service `firestore.get()`/`firestore.exists()` calls from Storage Rules reliably fail closed on this project for every operator tested, across two independent investigation rounds; a first theory (missing `firebaserules.firestoreServiceAgent` IAM role) was proposed, then proven wrong via direct IAM policy inspection and Google's own role reference. The true root cause remains genuinely unexplained. **Workaround, not a fix**: `functions/scripts/setAdminClaims.js` is a one-time, manually-run script (`cd functions && node scripts/setAdminClaims.js <uid>`, targets the real `bloodlink-dev-wt` project via `firebase-admin`) that sets the Firebase Auth custom claim `admin: true` on a given uid. Storage Rules' `isAdmin()` (`storage.rules`) now checks `request.auth.token.admin == true` instead of the broken Firestore lookup — **Firestore rules are unchanged**, `firestore.rules`' `isAdmin()` still uses the Firestore `roles` array, which was never broken. Re-verified with the same before/after `gcloud storage ls` rigor as the original bug report: admin writes to `bannerImages/*` now succeed. **Since there are only ever 2 admin accounts (§2), custom claims are set manually, not auto-synced from the `roles` array — if a 3rd admin is ever added, or an existing admin account is replaced, `functions/scripts/setAdminClaims.js` must be re-run for that account's uid, or Storage writes will silently fail for them** (Firestore-backed admin checks are unaffected, since those don't depend on this claim). **3A-2 is now genuinely unblocked.** The underlying cross-service bridge bug itself is still unexplained and low-priority now that Storage doesn't depend on it — a genuine Firebase support ticket remains the right next step if it's ever worth pursuing for its own sake.
- **Stale FCM tokens are never invalidated (2A-7).** `notifyUsers` (`functions/src/notifications/notify.ts`) can tell a dead token (`messaging/registration-token-not-registered`, `messaging/invalid-registration-token`) apart from a transient send failure and logs them distinctly, but it doesn't clear `users/{uid}.fcmToken` on a dead-token result. A donor/requester who uninstalls, reinstalls, or switches devices without the app re-registering a fresh token will keep the old dead token in Firestore, and every future push to them will fail the same way, silently, forever. Needs a cleanup path (e.g. clear the field inline on a dead-token result) before relying on push delivery at scale.
- **`BannerItemModel`/`BannerItemRepository` has no `updatedBy` field — a 3A-1 gap, not inherited from earlier work.** Both were built in 3A-1 alongside the rest of the banner-carousel feature. The model only carries `createdBy` (set once, at creation) and `updatedAt`; `updateBanner`, `setActive`, and 3A-2's new `setDisplayOrder` all bump `updatedAt` but none of them write an acting-admin uid anywhere. This falls short of §5's "every admin write is timestamped and attributed" for every write except the original create. Found while building 3A-2's reorder/toggle controls, which inherit the gap rather than introduce it — surfacing here rather than silently adding the field, since fixing it means a schema change (new field + backfill decision for the two existing live banners) that whoever revisits the banner data model should make deliberately, not as a side effect of an unrelated screen.

If a task depends on one of these being resolved, say so explicitly rather than picking an answer and moving on.

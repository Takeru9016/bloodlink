# bloodlink — Phase 4B Prompts

Gap closure: features that were checked off in earlier phases but are still not actually
reachable or wired end-to-end, plus router placeholders left over from Phase 1–4A. Found
via a full-app audit on 2026-08-05 (see that conversation for the complete findings list).

Requires Phase 4A complete. Copy-paste each prompt as-is into Claude Code. One task per session.

**Not in this phase — do not attempt without separate confirmation:**
- Profile stats (lives saved/donations/rating), badges, direct donor-to-donor requests,
  and `request_nearby`'s notification target are all blocked on the same unresolved
  donor-to-request-attribution data-model decision (CLAUDE.md §7). Don't build against a
  guessed schema.
- Release-signing Maps keys, a `bloodlink-prod` Firebase project, and live-device
  verification (iOS FCM, Android cold-start FCM, camp RSVP against a real emulator) all
  need manual console/device work outside what a coding session can do — track them as a
  pre-launch checklist, not a coding task here.
- Final brand name and target compliance region are still open per CLAUDE.md's header —
  don't let any task in this phase quietly treat "bloodlink" or the current palette as final.

---

## 4B-1 — Wire Report/Block UI into real screens

```
Read @CLAUDE.md @lib/shared/widgets/report_button.dart @lib/data/repositories/report_repository.dart

Task 4B-1: Place ReportButton on the screens it was built for

ReportButton (built in 2A-9) is never imported anywhere outside its own file — the
report/block feature has no UI entry point in the running app, even though 2A-9 is
checked off in docs/PHASES.md. Add it to:
- lib/features/donor_directory/presentation/donor_directory_screen.dart (report a donor)
- lib/features/bank_locator/presentation/bank_profile_screen.dart (report a partner listing)

Follow whatever target-type/target-id contract ReportButton and ReportModel already
define — don't change the model, this is a wiring task only. If ReportButton's existing
API doesn't cleanly support one of these two contexts, say so and propose the smallest
change before writing it.

State the build plan first. Wait for confirmation.
```

**Done.** `ReportTargetType` only had `request`/`donor` — added `partner` (additive, no rule change needed since firestore.rules doesn't gate on targetType) so bank_profile_screen.dart's report could be labeled correctly rather than mislabeled as a donor report. `report_repository.dart`'s manual `_targetTypeJson` map needed the new case too (it isn't derived from the enum, easy to miss). See 4B-1a below for the test-coverage gap this surfaced.

---

## 4B-1a — Widget tests for donor_directory_screen.dart + bank_profile_screen.dart

Not in the original audit list — surfaced while landing 4B-1: neither screen had any widget-test coverage at all (pre-existing gap, not introduced by 4B-1), so the new ReportButton wiring had nothing checking it either. Closed immediately rather than deferred, since both test files were small and directly validate 4B-1's change.

**Done.** Added `test/features/donor_directory/presentation/donor_directory_screen_test.dart` (blood-group-not-selected state, empty-results state, populated list with badge/distance, and asserts one `ReportButton` per donor card with `targetType: .donor` + the correct `targetId`) and `test/features/bank_locator/presentation/bank_profile_screen_test.dart` (renders partner info, asserts the `ReportButton` has `targetType: .partner` + `targetId: bankId`). Both follow the existing fake-`Notifier`/provider-override pattern used elsewhere in this test suite (no real Firebase). `flutter analyze` clean, `flutter test` 51/51 passing (was 47).

---

## 4B-2 — Admin: Moderation screen

```
Read @CLAUDE.md @lib/data/repositories/report_repository.dart @lib/features/admin/verify_donors/presentation/verify_donors_screen.dart

Task 4B-2: Build lib/features/admin/moderation/presentation/moderation_screen.dart

Replace the `_TodoScreen('Admin: Moderation')` placeholder in app_router.dart. List open
reports via ReportRepository.listOpenReports(), following the review-queue pattern
verify_donors_screen.dart already established (1B-era list + per-item action). Each report
needs at minimum a "resolve"/"dismiss" action that updates its status — check
report_model.dart for what statuses already exist before inventing new ones.

Every admin action here must set updatedBy/updatedAt per CLAUDE.md §5 — check
report_repository.dart already enforces this on writes; if it doesn't, that's a
repository gap to fix as part of this task, not a separate one.

State the build plan first. Wait for confirmation.
```

---

## 4B-3 — Admin: Manage Education Hub screens + Storage rules

```
Read @CLAUDE.md @docs/DATA_MODEL.md @lib/features/admin/manage_carousel @storage.rules

Task 4B-3: Build lib/features/admin/manage_education_hub/ (list/new/edit) and add
education-article Storage rules

lib/features/admin/manage_education_hub/ doesn't exist yet, despite being named in
CLAUDE.md §4's repo structure. Replace the three `_TodoScreen` placeholders in
app_router.dart (adminEducationName, adminEducationNewName, adminEducationEditName) with
real screens, following manage_carousel_screen.dart's (3A-2) list+form pattern — that's
the closest existing admin CRUD-with-image-upload feature. Content currently only exists
via functions/scripts/seedEducationArticles.js; this task is what makes ongoing edits
possible without re-running that script.

storage.rules has no rule for education-article images at all (only donorVerification/*
and bannerImages/* are covered) — add a matching block, admin-write / public-read, same
shape as bannerImages/*, before wiring the upload path so it doesn't fail closed.

Every write needs updatedBy/updatedAt per CLAUDE.md §5.

State the build plan first. Wait for confirmation.
```

---

## 4B-4 — Donation history screen

```
Read @CLAUDE.md @docs/SPEC.md @lib/data/repositories/donor_profile_repository.dart

Task 4B-4: Build lib/features/donor_profile/presentation/donation_history_screen.dart
(or profile/presentation/, match wherever docs/SPEC.md places it)

Replace the `_TodoScreen('Donation history')` placeholder. Check docs/SPEC.md's spec for
this screen first. Note: donorProfiles only has a single nullable lastDonationDate field,
not a list of past donations — if a real history list isn't backed by any existing
collection, do not fabricate one. Build what the real data supports (e.g. last donation
date, verification status) and say explicitly if the "full history list" part of the spec
has no data source yet, same honest-placeholder treatment Profile's stats row already
uses (see CLAUDE.md §7). Don't invent a new collection without flagging it first.

State the build plan first. Wait for confirmation.
```

---

## 4B-5 — Settings screen

```
Read @CLAUDE.md @docs/SPEC.md @lib/features/profile/presentation/profile_screen.dart

Task 4B-5: Build lib/features/profile/presentation/settings_screen.dart

Replace the `_TodoScreen('Settings')` placeholder. Check docs/SPEC.md for what this
screen should contain. At minimum this is likely notification preferences and account
info editing backed by user_repository.dart/donor_profile_repository.dart — do not add
settings toggles that don't write anywhere real.

State the build plan first. Wait for confirmation.
```

---

## 4B-6 — Help & support screen

```
Read @CLAUDE.md @docs/SPEC.md

Task 4B-6: Build lib/features/profile/presentation/help_support_screen.dart

Replace the `_TodoScreen('Help & support')` placeholder. Check docs/SPEC.md for expected
content — likely static FAQ/contact content, no new data model needed. Keep it simple;
this is the smallest task in this phase.

State the build plan first. Wait for confirmation.
```

---

## 4B-7 — Stale FCM token cleanup

```
Read @CLAUDE.md @functions/src/notifications/notify.ts

Task 4B-7: Clear dead FCM tokens from Firestore

notify.ts already distinguishes a dead-token failure (messaging/registration-token-not-registered,
messaging/invalid-registration-token) from a transient send failure and logs it, but never
clears users/{uid}.fcmToken when it happens — see the comment at notify.ts:17. Add that
write inline on a dead-token result so a reinstalled/switched-device user doesn't keep
failing pushes silently forever.

State the build plan first. Wait for confirmation.
```

---

## 4B-8 — BannerItem admin-write attribution

```
Read @CLAUDE.md §5 @lib/data/models/banner_item_model.dart @lib/data/repositories/banner_item_repository.dart

Task 4B-8: Add updatedBy to BannerItemModel and every write path

BannerItemModel only records createdBy (set once) — updateBanner, setActive, and
setDisplayOrder all bump updatedAt but none write an acting-admin uid, which falls short
of CLAUDE.md §5's "every admin write is timestamped and attributed" rule for every write
after creation. Add an updatedBy field, thread the acting admin's uid through every write
method in banner_item_repository.dart, and decide (state your reasoning, then apply it)
what the two existing live banners' updatedBy should backfill to — do not leave it null
for pre-existing docs if that's avoidable.

State the build plan first. Wait for confirmation.
```

---

## Phase 4B Gate Check

```
Run the following and report all output:

flutter analyze     # must report 0 issues
flutter test        # must pass

Then manually verify and report:
1. ReportButton is reachable from both donor directory and bank profile, and a submitted
   report is visible in the new Admin Moderation screen
2. Admin can list, create, and edit an education article end-to-end (no more _TodoScreen
   anywhere in app_router.dart's education routes) and an article image upload succeeds
   against the new Storage rule
3. Donation history, Settings, and Help & support are real screens, not _TodoScreen
4. notify.ts clears fcmToken on a dead-token send result — confirm by reading the code,
   this doesn't need a live device
5. Every BannerItemModel write path sets updatedBy, and the two pre-existing banners have
   a non-null value for it

Then confirm:
1. grep -rn "_TodoScreen" lib/core/router/app_router.dart returns nothing
2. All tasks in Phase 4B are checked off in docs/PHASES.md
3. Update docs/PHASES.md's progress tracker and the total at the bottom of the file
4. Update CLAUDE.md's "Active Task" line to point to whatever remains — if everything
   above is done, and the only things left are the "Not in this phase" items listed at
   the top of this file, say so explicitly rather than declaring the project fully done;
   those items are still open and need a decision from the user, not more code.

Report PASS or FAIL. Flag anything that still feels unfinished rather than declaring the
phase done by default.
```

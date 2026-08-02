# bloodlink — Phase 3A Prompts

Engagement layer: home carousel, donor directory, profile, notification center.
Requires Phase 2A complete. Copy-paste each prompt as-is into Claude Code. One task per session.

---

## 3A-1 — bannerItems model + repository

```
Read @CLAUDE.md @docs/DATA_MODEL.md §bannerItems

Task 3A-1: Build lib/data/models/banner_item_model.dart and
lib/data/repositories/banner_item_repository.dart

Model: freezed + json_serializable — imageUrl, linkedPartnerId (nullable), displayOrder,
active, createdBy, updatedAt.

Repository: listActiveBanners() (ordered by displayOrder, active == true only),
listAllBanners() (for the admin screen, includes inactive), uploadBannerImage(File image):
Future<String> (uploads to Cloud Storage, returns download URL — the create/update methods
should accept this URL, not the raw file, keeping the upload concern separate from the
Firestore write), createBanner, updateBanner, setActive(id, bool).

Admin-only write enforcement matches the pattern from partner_repository.dart (1A-12) —
pass adminUid and verify role before writing.

State the build plan first. Wait for confirmation.
```

---

## 3A-2 — Admin: Manage home carousel screen

```
Read @CLAUDE.md @docs/SPEC.md §Manage home carousel @lib/data/repositories/banner_item_repository.dart @lib/data/repositories/partner_repository.dart

Task 3A-2: Build lib/features/admin/manage_carousel/presentation/manage_carousel_screen.dart

Requirements per SPEC.md:
- List of banners (listAllBanners) with active/inactive AppBadge (1A-5) per row
- "+ Upload banner" → image picker → BannerItemRepository.uploadBannerImage →
  optional "link to partner" dropdown (sourced from PartnerRepository.listPartners) →
  display order input → createBanner
- Toggle active/inactive per row (setActive) without deleting
- Reorder: simple up/down control per row updating displayOrder — do not build a
  drag-and-drop reorder UI, a basic control is sufficient for v1

State the build plan first. Wait for confirmation.
```

---

## 3A-3 — Home screen

```
Read @CLAUDE.md @docs/SPEC.md §Home @lib/data/repositories/banner_item_repository.dart @lib/data/repositories/partner_repository.dart @lib/data/repositories/blood_request_repository.dart

Task 3A-3: Build lib/features/home/presentation/home_screen.dart

Requirements per SPEC.md:
- Top bar: menu icon, "Home" title, notification bell (badge if unread notifications exist)
- Banner carousel: auto-rotating, from BannerItemRepository.listActiveBanners. Empty state
  if no active banners — do not show a broken/blank carousel. Tap a banner → full-screen
  image viewer modal (swipeable if multiple images, pinch-to-zoom). If linkedPartnerId is
  set, show a "View bank" button in the viewer navigating to bank_profile_screen (1B-9).
- Quick actions row: Request blood / Find bank / Donor list, navigating to the respective
  screens
- "Trusted partners" static grid — can reuse PartnerRepository's most-recently-verified
  partners, separate from the rotating carousel above
- Local demand snapshot: a simple count of bloodRequests with status "pending" in the
  user's general area — a rough implementation is fine, this is a supporting stat, don't
  over-invest here relative to the carousel
- Bottom nav: Home, Request, Banks, Donors, Profile (from the router shell built in 1A-6)

State the build plan first. Wait for confirmation.
```

---

## 3A-4 — Donor directory screen

```
Read @CLAUDE.md @docs/SPEC.md §Donor directory @lib/data/repositories/donor_profile_repository.dart

Task 3A-4: Build lib/features/donor_directory/presentation/donor_directory_screen.dart

Requirements per SPEC.md:
- Search/filter by blood group and distance, using
  DonorProfileRepository.queryVerifiedDonors (1A-11) — this method already enforces the
  verified-only filter, do not build a separate query here that bypasses it
- Each row: avatar, name, distance, blood group AppBadge (1A-5)

State the build plan first. Wait for confirmation.
```

---

## 3A-5 — Profile screen

```
Read @CLAUDE.md @docs/SPEC.md §Profile @lib/data/repositories/blood_request_repository.dart @lib/data/repositories/donor_profile_repository.dart

Task 3A-5: Build lib/features/profile/presentation/profile_screen.dart

Requirements per SPEC.md:
- Avatar, name, blood group (from DonorProfileModel)
- Stats row: lives saved (count of fulfilled requests tied to this donor), donations
  count, rating — these MUST be computed from real BloodRequestRepository/donor data, not
  hardcoded. If a formal "donation record" doesn't cleanly exist yet, derive the count from
  bloodRequests where status == "fulfilled" and this donor was the fulfilling party — if
  the current data model doesn't capture "which donor fulfilled this request" anywhere,
  add that field to BloodRequestModel and docs/DATA_MODEL.md now rather than faking the stat
- Menu: Donation history, Badges (stub screen — real implementation is Phase 4A-4),
  Settings, Help & support, Log out

State the build plan first. Wait for confirmation.
```

---

## 3A-6 — In-app notification center

```
Read @CLAUDE.md @docs/SPEC.md §Notifications @docs/DATA_MODEL.md §notifications

Task 3A-6: Build lib/data/repositories/notification_repository.dart and
lib/features/notifications/presentation/notification_center_screen.dart

notification_repository.dart: listForUser(uid) grouped by today/earlier, markAsRead(id).

notification_center_screen.dart: grouped Today/Earlier list, read/unread visual state,
inline actions where relevant (e.g. "Accept" button on a request_nearby notification).
Tapping a notification navigates based on its `type` field — enumerate every type
2A-7's Cloud Functions actually emit ("request_nearby", "request_status") and make sure
each has a working navigation case. Do not leave a type unhandled — if a new type shows up
that isn't in this list, treat that as a bug to fix, not something to silently ignore.

State the build plan first. Wait for confirmation.
```

---

## Phase 3A Gate Check

```
Run the following and report all output:

flutter analyze     # must report 0 issues
flutter test        # must pass

Then manually verify and report:
1. Home's banner carousel is driven entirely by real bannerItems data curated through
   3A-2's admin screen — upload a banner as admin, confirm it appears live on Home
2. Tapping a banner opens the full-screen viewer; a linked banner routes to the correct
   bank profile
3. Donor directory still excludes unverified donors (regression check against 1A-11/2A-8)
4. Profile's stats reflect real data, not placeholders
5. In-app notification center correctly handles every notification type the backend emits
6. REQUIRED, live-device/emulator only — 3A-3's navigation/lifecycle fixes were written and
   analyze/test-passed with no emulator available that session (see CLAUDE.md §7's 3A-3
   entries) and are unverified beyond reasoning through the go_router/Flutter APIs. This is
   exactly the class of bug (RequestStatusScreen, main.dart's unwired entry point, the lost
   router wiring) this project has been burned by before — do not let a green /check stand
   in for this. Check each explicitly:
   a. Open the banner viewer from Home, tap the close (X) button — confirm it pops back to
      Home (not a dead end, not a crash). This depends on the viewer having been `pushNamed`
      to, not `goNamed`.
   b. Open the banner viewer, wait past one auto-rotate interval (5s) with a multi-banner
      carousel, close it — confirm the carousel is still on the page you left it on, not
      one it silently advanced to while the viewer was on top.
   c. Tap the notifications bell from Home, then use back navigation — confirm it returns
      to Home with the bottom nav intact, not a dead end.
   d. From Home, tap each quick action (Request blood / Find bank / Donor list) one at a
      time, then tap the Home tab in the bottom nav — confirm the correct tab highights
      each time and Home's own state (carousel position, scroll) survived.
   e. Open the drawer (menu icon), tap Education hub, Donation history, and Settings in
      turn (separately, returning to Home between each) — confirm each returns to Home via
      back navigation, not a dead end. Then tap Profile from the drawer — confirm it
      switches the bottom nav to the Profile tab correctly.
   Do not check off 3A-3 as fully verified, and do not treat this Gate Check as PASS, until
   6a–6e have each been confirmed on a real device or emulator and reported individually.

Then confirm:
1. All 6 Phase 3A tasks are checked off in docs/PHASES.md
2. CLAUDE.md "Active Task" now points to 4A-1
3. Update docs/PHASES.md progress tracker: Phase 3A [ 6 / 6 tasks ] 100%, and update the
   total at the bottom of the file

Report PASS or FAIL with details on any failure before I proceed to Phase 4A.
```

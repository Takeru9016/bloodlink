# bloodlink — Phase 1B Prompts

Stage 1 screens: auth, admin partner/stock management, bank locator.
Requires Phase 1A complete (models, repositories, theme, shared widgets, router skeleton, rules deployed).
Copy-paste each prompt as-is into Claude Code. One task per session.

---

## 1B-1 — Onboarding screens

```
Read @CLAUDE.md @docs/SPEC.md §Onboarding & Auth @docs/DESIGN_SYSTEM.md

Task 1B-1: Build lib/features/onboarding/presentation/onboarding_screen.dart

Requirements per docs/SPEC.md §Onboarding:
- 3 swipeable screens (PageView): "Find blood, save lives" / "Need blood? Just a tap away" /
  "Secure blood for surgeries & emergencies" — use the exact copy from SPEC.md
- Skippable at any point via a top-right "Skip" text button — jumps straight to Sign up
- Pagination dots at the bottom reflecting current page
- Last screen's primary action navigates to Sign up (route from 1A-6's router)
- Use AppButton (1A-3) for any buttons, AppTheme (1A-2) for all colors/type — no hardcoded
  styling

State the build plan first. Wait for confirmation.
```

---

## 1B-2 — Sign up screen

```
Read @CLAUDE.md @docs/SPEC.md §Sign up @docs/data/repositories/user_repository.dart

Task 1B-2: Build lib/features/auth/presentation/sign_up_screen.dart and
lib/features/auth/application/auth_controller.dart

sign_up_screen.dart:
- Fields per SPEC.md: Full name, Email, Password — use AppInput (1A-4) with Form validation
  (name required, email format, password min 8 chars)
- "Continue with Google" button (Firebase Auth Google provider)
- On submit: create Firebase Auth user, then call UserRepository.createUser with
  roles: [] — do not assign a role here, that happens in role selection / 1B-4

auth_controller.dart:
- @riverpod annotated controller (riverpod_generator, per CLAUDE.md §3 — no manual
  StateNotifierProvider) wrapping sign-up/sign-in/sign-out logic
- Exposes loading/error state for the UI to react to (AppButton's isLoading prop from 1A-3)

Run build_runner after adding @riverpod annotations.

State the build plan first. Wait for confirmation.
```

---

## 1B-3 — Sign in screen

```
Read @CLAUDE.md @docs/SPEC.md §Sign in @lib/features/auth/application/auth_controller.dart

Task 1B-3: Build lib/features/auth/presentation/sign_in_screen.dart

Requirements per SPEC.md:
- Fields: Email, Password (AppInput, 1A-4)
- "Continue with Google" button
- "Forgot password" link → Firebase Auth sendPasswordResetEmail flow (simple confirmation
  dialog/snackbar after sending, no custom screen needed)
- Reuse auth_controller.dart (1B-2) for sign-in logic — do not duplicate auth logic here

State the build plan first. Wait for confirmation.
```

---

## 1B-4 — Donor profile setup screen

```
Read @CLAUDE.md @docs/SPEC.md §Donor profile setup @docs/DATA_MODEL.md §donorProfiles

Task 1B-4: Build lib/features/donor_profile/presentation/donor_profile_setup_screen.dart

Requirements per SPEC.md:
- Blood group dropdown (8 values: A+/A-/B+/B-/O+/O-/AB+/AB-)
- Date of birth date picker — validate 18+ on submit (block submission with a clear error
  if under 18, do not silently allow it)
- City/location: request device location permission, fall back to a manual text entry field
  if denied — do not force the permission, this must be usable without it
- Last donation date: optional date picker, nullable
- On submit: DonorProfileRepository.createOrUpdateProfile (1A-11), then
  UserRepository.updateRoles to add "donor" to the current roles array (1A-10) —
  don't overwrite existing roles, append to them
- This screen is reachable from role selection after sign-up, and skippable if the user
  only wants the "requester" role — confirm the skip path routes correctly in 1A-6's router

State the build plan first. Wait for confirmation.
```

---

## 1B-5 — Auth state provider + router wiring

```
Read @CLAUDE.md @lib/core/router/app_router.dart @lib/features/auth/application/auth_controller.dart

Task 1B-5: Wire real auth state into lib/core/router/app_router.dart

Requirements:
- Replace 1A-6's stubbed auth-state placeholder with a real @riverpod authStateProvider
  wrapping Firebase Auth's authStateChanges() stream combined with the user's roles
  (fetched via UserRepository.watchUser)
- Redirect logic: signed out → onboarding/sign-in; signed in with no roles chosen yet →
  role selection; signed in with roles → appropriate home (consumer or admin shell based
  on whether "admin" is in roles)
- An "admin" role takes them to the admin shell, never the consumer bottom-nav shell —
  confirm this by testing both role combinations, not just admin
- Run build_runner after adding the @riverpod provider

State the build plan first. Wait for confirmation.
```

---

## 1B-6 — Admin: Manage partners screen

```
Read @CLAUDE.md @docs/SPEC.md §Manage partners @lib/data/repositories/partner_repository.dart

Task 1B-6: Build lib/features/admin/manage_partners/presentation/manage_partners_screen.dart
and partner_form_screen.dart

manage_partners_screen.dart:
- List of partner banks (PartnerRepository.listPartners), each row shows name + AppBadge
  (1A-5) reflecting verificationStatus (Verified/Pending)
- "+ Add new partner" button → navigates to partner_form_screen.dart in create mode
- Tapping a row → partner_form_screen.dart in edit mode

partner_form_screen.dart:
- Fields: name, address, phone, geo-location (map picker using google_maps_flutter —
  tap-to-pin interaction is sufficient, no need for full address autocomplete in v1)
- Edit mode: pre-fill from the existing PartnerModel, plus a verify/deactivate toggle
  (writes verificationStatus)
- On submit: PartnerRepository.createPartner or updatePartner (1A-12), passing the
  current admin's uid — confirm this screen is only reachable by admin-role users via
  the router's role gate (1A-6/1B-5), do not add a redundant in-screen check as the only
  protection

State the build plan first. Wait for confirmation.
```

---

## 1B-7 — Admin: Update stock screen

```
Read @CLAUDE.md @docs/SPEC.md §Update stock @lib/data/repositories/partner_repository.dart

Task 1B-7: Build lib/features/admin/update_stock/presentation/update_stock_screen.dart

Requirements per SPEC.md:
- Partner selector (dropdown or searchable list, from PartnerRepository.listPartners)
- On partner selected: load current stock via PartnerRepository.getStock, pre-fill an
  8-cell grid (A+/A-/B+/B-/O+/O-/AB+/AB-) with numeric inputs (AppInput, 1A-4, numeric
  keyboard type)
- "Save stock update" button (AppButton, 1A-3): for each changed cell, call
  PartnerRepository.updateStock with the current admin's uid — this is the screen where
  the lastUpdatedBy/lastUpdatedAt attribution matters most (CLAUDE.md §5), confirm every
  save path goes through updateStock and never a raw Firestore write

State the build plan first. Wait for confirmation.
```

---

## 1B-8 — Bank locator screen

```
Read @CLAUDE.md @docs/SPEC.md §Bank locator @lib/data/repositories/partner_repository.dart

Task 1B-8: Build lib/features/bank_locator/presentation/bank_locator_screen.dart

Requirements per SPEC.md:
- List/map toggle (google_maps_flutter for the map view, pins per partner)
- List view: search bar filtering by name/location (client-side filter on
  PartnerRepository.listPartners results is fine for this data volume — no need for a
  dedicated search index yet)
- Each row/pin: bank name, distance from user (geolocator), address snippet
- Map pin tap → bottom sheet summary → "View profile" navigates to bank_profile_screen
  (1B-9)

State the build plan first. Wait for confirmation.
```

---

## 1B-9 — Bank profile screen

```
Read @CLAUDE.md @docs/SPEC.md §Bank locator (Bank profile) @lib/data/repositories/partner_repository.dart

Task 1B-9: Build lib/features/bank_locator/presentation/bank_profile_screen.dart

Requirements per SPEC.md:
- Hero header with bank name
- Location, phone
- 8-cell stock grid (A+/A-/B+/B-/O+/O-/AB+/AB-) via PartnerRepository.watchStock (1A-12) —
  use the stream so this screen reflects admin stock updates live, not just on screen load
- "Stock last updated" timestamp — compute as the most recent lastUpdatedAt across all
  8 stock docs, not a single hardcoded field
- Continue/Contact button (behavior can be a simple phone-dial intent for v1 — full
  "reserve stock" flow is Phase 2A's Request blood feature, not this screen)

State the build plan first. Wait for confirmation.
```

---

## Phase 1B Gate Check

After all 9 tasks above are complete and committed, run this final verification prompt:

```
Run the following and report all output:

flutter analyze     # must report 0 issues
flutter test        # must pass

Then manually verify and report:
1. An admin can add a partner bank and update its stock through the app
2. That partner + stock is visible to a signed-in consumer in the bank locator, with a
   correct "last updated" timestamp
3. A non-admin user cannot reach any admin route, even by manually navigating to the
   route path
4. A new user can complete sign up → donor profile setup → land on a real data-backed
   screen with no mock data anywhere in that path

Then confirm:
1. All 9 Phase 1B tasks are checked off in docs/PHASES.md
2. CLAUDE.md "Active Task" now points to 2A-1
3. Update docs/PHASES.md progress tracker: Phase 1B [ 9 / 9 tasks ] 100%, and update the
   total at the bottom of the file

Report PASS or FAIL with details on any failure before I proceed to Phase 2A.
```

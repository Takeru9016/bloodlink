# bloodlink — Phase 1A Prompts

Foundation tasks. No design references needed yet. Complete in order.
Copy-paste each prompt as-is into Claude Code. One task per session.
Task codes match `docs/PHASES.md` exactly.

---

## 1A-1 — pubspec.yaml dependencies

```
Read @CLAUDE.md @INSTALL.md

Task 1A-1: Add project dependencies to pubspec.yaml

Requirements:
- Add: flutter_riverpod, riverpod_annotation, firebase_core, firebase_auth, cloud_firestore,
  firebase_storage, cloud_functions, firebase_messaging, google_maps_flutter, geolocator, go_router
- Add dev_dependencies: freezed_annotation, json_annotation, build_runner, freezed,
  json_serializable, riverpod_generator, riverpod_lint
- Run: flutter pub get
- Confirm the project still builds (flutter analyze) with only "unused import" style warnings
  at worst — no dependency resolution errors

Do NOT add any package not listed in CLAUDE.md §3 (Provider, GetX, Bloc, Dio, http, etc. are
explicitly not this project's stack — do not add them even if they seem convenient).

State the build plan first. Wait for confirmation.
```

---

## 1A-2 — Theme

```
Read @CLAUDE.md @docs/DESIGN_SYSTEM.md

Task 1A-2: Build lib/core/theme/app_theme.dart

Requirements:
- Define every color token from DESIGN_SYSTEM.md §Colors as a ThemeExtension<AppColors>
  (brandRed, brandRedDark, textPrimary, textSecondary, surface, surfaceMuted, border,
  success, amber) — do NOT hardcode hex values anywhere outside this file
- Define TextTheme entries matching DESIGN_SYSTEM.md §Typography (Page heading 24/Bold,
  Section heading 18/SemiBold, Body 15/Regular, Secondary 13/Regular, Caption 12/Medium),
  font family Inter
- Export a single `AppTheme.light` ThemeData (this is a flat, single-mode design system per
  the Figma reference — no dark mode variant needed unless told otherwise)
- Corner radius constants: buttons/inputs 8px, cards 10-14px — define as named constants,
  not magic numbers, so §Layout changes later are a one-file edit

Do NOT create tailwind-style config files — this is Flutter, everything lives in this
ThemeData/ThemeExtension setup.

State the build plan first. Wait for confirmation.
```

---

## 1A-3 — AppButton

```
Read @CLAUDE.md @docs/DESIGN_SYSTEM.md §Components

Task 1A-3: Build lib/shared/widgets/app_button.dart

Requirements:
- AppButton widget with a required `label`, `onPressed`, and a `variant` enum: `filled | outline`
- filled: brandRed fill, white 14/SemiBold label, 44-46px height, 8px corner radius
- outline: transparent fill, border-token stroke, textPrimary label
- Loading state: `isLoading: bool` prop — shows a small spinner in place of the label, disables
  the tap target
- Disabled state when `onPressed` is null — visually muted, not tappable
- Pull all colors/text styles from AppTheme (1A-2) via `Theme.of(context)` — no hardcoded values

State the build plan first. Wait for confirmation.
```

---

## 1A-4 — AppInput

```
Read @CLAUDE.md @docs/DESIGN_SYSTEM.md §Components

Task 1A-4: Build lib/shared/widgets/app_input.dart

Requirements:
- AppInput widget: `label` (shown above the field, 12/Medium per design system),
  `controller`, `hintText`, `obscureText` (for passwords), `validator`, `keyboardType`
- Field styling: surface fill, border-token stroke, 8px corner radius, 44px height
- Error state: shows validator's error text below the field in a distinguishable color
  (use a sensible error red — do not invent a new undocumented token, reuse `destructive`-style
  semantics or ask if DESIGN_SYSTEM.md needs an error color added)
- Must work inside a Form/TextFormField pattern (for use with form-level validation)

State the build plan first. Wait for confirmation.
```

---

## 1A-5 — AppCard + AppBadge

```
Read @CLAUDE.md @docs/DESIGN_SYSTEM.md §Components

Task 1A-5: Build lib/shared/widgets/app_card.dart and app_badge.dart

app_card.dart:
- AppCard widget: wraps `child`, surfaceMuted fill, 10-14px corner radius, no shadow
  (flat design per DESIGN_SYSTEM.md — do not add elevation/shadow)
- Optional `onTap` for tappable cards (e.g. bank list rows)
- Standard padding per DESIGN_SYSTEM.md §Layout (20px horizontal reference, adjust to
  card context sensibly)

app_badge.dart:
- AppBadge widget: `label`, `variant` enum: `verified | pending | off`
- verified: success color text on tinted success background
- pending: amber color text on tinted amber background
- off: textSecondary on surfaceMuted
- Pill shape (~6px corner radius per spec)

State the build plan first. Wait for confirmation.
```

---

## 1A-6 — Router skeleton

```
Read @CLAUDE.md @docs/SPEC.md

Task 1A-6: Build lib/core/router/app_router.dart

Requirements:
- go_router setup with named routes for every screen in docs/SPEC.md, even though most
  screens don't exist yet — use placeholder `Scaffold(body: Text('TODO: <name>'))` widgets
  for any screen not yet built, so the route table is complete from the start
- Route groups: auth/onboarding (no shell), consumer (bottom-nav shell: Home, Request,
  Banks, Donors, Profile), admin (separate nav shell — per CLAUDE.md, admin has its own
  navigation, not tabs mixed into the consumer bottom nav)
- Role-gating: redirect logic based on the signed-in user's `roles` — a user without
  "admin" in roles must never be able to navigate into an admin route, even by deep link
- This is scaffolding only — do NOT wire real auth state yet (that's 1B-5). For now, stub
  the auth-state check with a placeholder provider that can be swapped later without
  changing this file's route structure

State the build plan first. Wait for confirmation.
```

---

## 1A-7 — UserModel

```
Read @CLAUDE.md @docs/DATA_MODEL.md §users

Task 1A-7: Build lib/data/models/user_model.dart

Requirements:
- freezed + json_serializable class matching docs/DATA_MODEL.md §users exactly:
  name, email, phone (nullable), roles (List<String>), location (GeoPoint — use
  cloud_firestore's GeoPoint type with a custom freezed converter), createdAt (Timestamp,
  same converter approach)
- Add an `fcmToken` field (nullable String) now even though it's not used until Phase 2A —
  note in a code comment that it's reserved for push notification setup
- Run: flutter pub run build_runner build --delete-conflicting-outputs after adding
  annotations

State the build plan first. Wait for confirmation.
```

---

## 1A-8 — DonorProfileModel

```
Read @CLAUDE.md @docs/DATA_MODEL.md §donorProfiles

Task 1A-8: Build lib/data/models/donor_profile_model.dart

Requirements:
- freezed + json_serializable class matching docs/DATA_MODEL.md §donorProfiles exactly:
  bloodGroup (String, but consider a BloodGroup enum with 8 values A+/A-/B+/B-/O+/O-/AB+/AB-
  for type safety — if you do this, document the enum here and make sure it serializes to/from
  the plain string Firestore expects), dob (Timestamp), lastDonationDate (nullable Timestamp),
  verificationStatus (enum: unverified | pending | verified), optInRadiusKm (double)
- Run build_runner after adding annotations

State the build plan first. Wait for confirmation.
```

---

## 1A-9 — PartnerModel + StockEntryModel

```
Read @CLAUDE.md @docs/DATA_MODEL.md §partners

Task 1A-9: Build lib/data/models/partner_model.dart and stock_entry_model.dart

partner_model.dart:
- freezed + json_serializable: name, address, location (GeoPoint), phone,
  verificationStatus (enum: pending | verified)

stock_entry_model.dart:
- freezed + json_serializable: unitCount (int), lastUpdatedBy (String, uid),
  lastUpdatedAt (Timestamp)
- This models one document in the partners/{id}/stock/{bloodGroup} subcollection —
  the bloodGroup itself is the document ID, not a field on the model

Run build_runner after adding annotations for both.

State the build plan first. Wait for confirmation.
```

---

## 1A-10 — UserRepository

```
Read @CLAUDE.md @docs/DATA_MODEL.md @docs/FIREBASE_SETUP.md

Task 1A-10: Build lib/data/repositories/user_repository.dart

Requirements:
- Typed methods only — no raw FirebaseFirestore.instance calls anywhere outside this file
  for the users collection
- getUser(String uid): Future<UserModel?>
- createUser(UserModel user): Future<void> — used right after Firebase Auth sign-up
- updateRoles(String uid, List<String> roles): Future<void>
- updateFcmToken(String uid, String token): Future<void> — reserved for Phase 2A, build
  the method now since the model field already exists (1A-7)
- watchUser(String uid): Stream<UserModel?> — for reactive UI (e.g. role-gated nav updates
  live if roles change)

State the build plan first. Wait for confirmation.
```

---

## 1A-11 — DonorProfileRepository

```
Read @CLAUDE.md @docs/DATA_MODEL.md @docs/FIREBASE_SETUP.md

Task 1A-11: Build lib/data/repositories/donor_profile_repository.dart

Requirements:
- getProfile(String uid): Future<DonorProfileModel?>
- createOrUpdateProfile(String uid, DonorProfileModel profile): Future<void>
- watchProfile(String uid): Stream<DonorProfileModel?>
- queryVerifiedDonors({required String bloodGroup, GeoPoint? near, double? radiusKm}):
  Future<List<DonorProfileModel>> — MUST filter verificationStatus == "verified" in the
  query itself, not as a post-filter in Dart. This is a trust & safety requirement per
  CLAUDE.md §5, not optional — an unverified donor must never come back from this method
  under any circumstance.

State the build plan first. Wait for confirmation.
```

---

## 1A-12 — PartnerRepository

```
Read @CLAUDE.md @docs/DATA_MODEL.md @docs/FIREBASE_SETUP.md

Task 1A-12: Build lib/data/repositories/partner_repository.dart

Requirements:
- getPartner(String id): Future<PartnerModel?>
- listPartners({bool verifiedOnly = false}): Future<List<PartnerModel>>
- createPartner(PartnerModel partner): Future<String> — returns new doc ID. Caller must be
  admin; enforce this by requiring an `adminUid` param and checking the calling user's roles
  via UserRepository before writing (defense in depth alongside Firestore rules — see
  CLAUDE.md §5, do not rely on rules alone)
- updatePartner(String id, PartnerModel partner): Future<void> — same admin check
- getStock(String partnerId): Future<Map<String, StockEntryModel>> — keyed by blood group
- updateStock(String partnerId, String bloodGroup, int unitCount, String adminUid):
  Future<void> — MUST set lastUpdatedBy: adminUid and lastUpdatedAt: FieldValue.serverTimestamp()
  on every call. This is the single most important attribution point in the whole app per
  CLAUDE.md §5 — do not make these fields optional or skip them under any code path.
- watchStock(String partnerId): Stream<Map<String, StockEntryModel>> — for the bank profile
  screen's live "last updated" display

State the build plan first. Wait for confirmation.
```

---

## 1A-13 — Firestore security rules

```
Read @CLAUDE.md @docs/FIREBASE_SETUP.md §Security rules

Task 1A-13: Build firestore.rules at the repo root

Copy the rules block from docs/FIREBASE_SETUP.md exactly — do not modify the logic, this
has already been reviewed against the data model.

After creating the file:
- Run: firebase deploy --only firestore:rules
- Report the deploy output

Do not proceed to mark this task complete until the deploy succeeds. If the Firebase project
isn't linked yet (no firebase.json / no flutterfire configure run), stop and tell me to
complete INSTALL.md's Firebase link step first — do not attempt to configure Firebase
project linkage yourself.

State the build plan first. Wait for confirmation.
```

---

## Phase 1A Gate Check

After all 13 tasks above are complete and committed, run this final verification prompt:

```
Run the following and report all output:

flutter analyze     # must report 0 issues
flutter test        # must pass (even if the only tests so far are trivial)
flutter pub run build_runner build --delete-conflicting-outputs   # must complete with no errors

Then confirm:
1. All 13 Phase 1A tasks are checked off in docs/PHASES.md
2. CLAUDE.md "Active Task" now points to 1B-1
3. Update docs/PHASES.md progress tracker: Phase 1A [ 13 / 13 tasks ] 100%, and update the
   total at the bottom of the file

Report PASS or FAIL with details on any failure before I proceed to Phase 1B.
```

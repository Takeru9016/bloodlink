# PHASES — task tracker

Task codes match `prompts/phase-*.md` exactly. Update checkboxes and the progress line as each task completes. `CLAUDE.md`'s "Active Task" line should always point to the next unchecked task.

## Phase 1A — Foundation (no screens, no design references needed)
- [x] 1A-1 — pubspec.yaml dependencies
- [x] 1A-2 — lib/core/theme/app_theme.dart
- [x] 1A-3 — lib/shared/widgets/app_button.dart
- [x] 1A-4 — lib/shared/widgets/app_input.dart
- [x] 1A-5 — lib/shared/widgets/app_card.dart + app_badge.dart
- [x] 1A-6 — lib/core/router/app_router.dart
- [x] 1A-7 — lib/data/models/user_model.dart
- [x] 1A-8 — lib/data/models/donor_profile_model.dart
- [x] 1A-9 — lib/data/models/partner_model.dart + stock_entry_model.dart
- [x] 1A-10 — lib/data/repositories/user_repository.dart
- [x] 1A-11 — lib/data/repositories/donor_profile_repository.dart
- [x] 1A-12 — lib/data/repositories/partner_repository.dart
- [x] 1A-13 — firestore.rules

Phase 1A [ 13 / 13 tasks ] 100%

## Phase 1B — Stage 1 screens (auth, admin partner/stock, bank locator)
- [x] 1B-1 — Onboarding screens
- [x] 1B-2 — Sign up screen
- [x] 1B-3 — Sign in screen
- [x] 1B-4 — Donor profile setup screen
- [x] 1B-5 — Auth state provider + router wiring
- [x] 1B-6 — Admin: Manage partners screen
- [x] 1B-7 — Admin: Update stock screen
- [x] 1B-8 — Bank locator screen
- [x] 1B-9 — Bank profile screen

Phase 1B [ 9 / 9 tasks ] 100%

## Phase 2A — Core request flow
- [x] 2A-1 — bloodRequests model + repository
- [x] 2A-2 — Cloud Function: onRequestCreated
- [x] 2A-3 — Request blood form screen
- [x] 2A-4 — Matched banks results screen
- [x] 2A-5 — Status tracking screen + updateRequestStatus function
- [x] 2A-6 — FCM token setup
- [x] 2A-7 — Cloud Functions: match + status notifications
- [x] 2A-8 — Donor verification flow
- [x] 2A-9 — Report/block feature
- [x] 2A-10 — educationArticles model + repository + seed content
- [x] 2A-11 — Education hub screens

Phase 2A [ 11 / 11 tasks ] 100%

## Phase 3A — Engagement layer
- [x] 3A-1 — bannerItems model + repository
- [x] 3A-2 — Admin: Manage home carousel screen
- [x] 3A-3 — Home screen
- [x] 3A-4 — Donor directory screen
- [x] 3A-5 — Profile screen
- [x] 3A-6 — In-app notification center

Phase 3A [ 6 / 6 tasks ] 100%

## Phase 4A — Extended features
- [x] 4A-1 — donationCamps model + repository
- [x] 4A-2 — Camp listing/detail/RSVP screens
- [x] 4A-3 — Admin: Manage camps screen
- [x] 4A-4 — Badges computation + Profile badges screen (skipped — no real donor-attributed fulfillment/acceptance data exists to back badges honestly; entry point removed rather than built on fabricated data, see CLAUDE.md §7)
- [x] 4A-5 — Direct donor-to-donor requests (skipped — never confirmed in scope per 4A-0, see CLAUDE.md §7; no code was written)

Phase 4A [ 5 / 5 tasks ] 100%

## Phase 4B — Gap closure (found via full-app audit, 2026-08-05)
- [x] 4B-1 — Wire Report/Block UI into real screens (added ReportTargetType.partner since the enum only had request/donor; donor_directory_screen.dart and bank_profile_screen.dart now each render a ReportButton; widget tests added for both screens as 4B-1a)
- [x] 4B-1a — Widget tests for donor_directory_screen.dart + bank_profile_screen.dart (neither screen had any prior coverage; added after landing 4B-1, covers rendering plus ReportButton wiring)
- [x] 4B-2 — Admin: Moderation screen (ReportRepository had no update path at all — added resolveReport/dismissReport with admin-gating and updatedBy/updatedAt per §5, plus the matching ReportModel fields; ModerationScreen mirrors verify_donors_screen.dart's list+per-item-action pattern)
- [x] 4B-3 — Admin: Manage Education Hub screens + Storage rules (built `lib/features/admin/manage_education_hub/` list+form, mirroring manage_carousel's image-upload pattern; added optional `imageUrl` to `educationArticles` (docs/DATA_MODEL.md) and an `educationImages/*` Storage rule; live-verified end-to-end on a real Android emulator against `bloodlink-dev-wt` — create, edit-preserves-image, and updatedBy/updatedAt attribution all confirmed via direct Firestore/Storage reads, see CLAUDE.md §7)
- [x] 4B-4 — Donation history screen (built `lib/features/donor_profile/presentation/donation_history_screen.dart` from `myDonorProfileProvider`; `donorProfiles` only carries a single nullable `lastDonationDate`, not a per-donation collection, so the screen shows blood group/verification status, last donation date (or "No donation recorded yet"), and an honest "Full history not tracked yet" note rather than fabricating a collection; live-verified against `bloodlink-dev-wt` on a Pixel 9 Pro emulator across all three real states — no donor profile, with `lastDonationDate`, without it — see CLAUDE.md §7)
- [x] 4B-5 — Settings screen (built `lib/features/profile/{application,presentation}/settings_controller.dart`/`settings_screen.dart` replacing the `_TodoScreen` placeholder; account name/phone editing via new `UserRepository.updateProfile`, and — donor-only — the nearby-request opt-in radius via new `DonorProfileRepository.updateOptInRadius` (gates `request_nearby` pushes in `filterNearbyDonors.ts`, previously unreachable — see the "Placeholder until Profile/Settings exposes opt-in radius" comment it replaced), plus a push-notification permission tile; email shown read-only, flagged as needing a Firebase Auth reauth flow not built here. Found and fixed a real layout bug along the way: a bare `AppButton` in a `Row` without `Expanded`/`IntrinsicWidth` throws on infinite-width constraints. Live-verified end-to-end against `bloodlink-dev-wt` on a Pixel 9 Pro emulator: a fresh throwaway donor account's account-info edit, all radius chip states including "Off", and the full push-permission revoke→Enable→OS-dialog→Allow flow all confirmed via direct Firestore reads, not just the app's own success state; test account and docs deleted afterward)
- [x] 4B-6 — Help & support screen (replaced the `_TodoScreen` placeholder with `lib/features/profile/presentation/help_support_screen.dart`; went beyond the phase prompt's "static content" default by explicit user instruction — admin-editable via two new collections, `helpFaqs/{faqId}` and singleton `appConfig/support`, deliberately separate from Education Hub's `"faq"`-category articles rather than reusing them. New admin surface: `lib/features/admin/manage_help_support/`, an 8th admin bottom-nav tab. `firestore.rules` updated/deployed and seeded via `functions/scripts/seedHelpSupport.js`; live-verified end-to-end on a Pixel 9 Pro emulator against `bloodlink-dev-wt` — consumer FAQ render + `mailto:` launch, and admin edits to both the FAQ and support email round-tripping through real Firestore with correct `updatedBy` attribution and showing up live on the consumer screen; test accounts/edits cleaned up afterward — see CLAUDE.md §7)
- [ ] 4B-7 — Stale FCM token cleanup
- [ ] 4B-8 — BannerItem admin-write attribution

Phase 4B [ 7 / 9 tasks ] 78%

---
**Total: 51 / 53 tasks**

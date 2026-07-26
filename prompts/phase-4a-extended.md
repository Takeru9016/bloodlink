# bloodlink — Phase 4A Prompts

Extended features: camps, badges, and (conditionally) direct donor-to-donor requests.
Requires Phase 3A complete. Copy-paste each prompt as-is into Claude Code. One task per session.

---

## 4A-0 — Scope confirmation (run this before anything else in this phase)

```
Read @CLAUDE.md §7

Task 4A-0: Confirm open decisions before Phase 4A begins

Check CLAUDE.md §7 "Known open items." Specifically ask me to confirm, in plain language,
before proceeding to 4A-1:
1. Has the direct donor-to-donor request decision been made? If yes, is it in scope for
   this phase or explicitly deferred?
2. Has a final brand name/visual identity been confirmed? (Informational — doesn't block
   this phase's work, but flag if it changes whether visual polish here is worth doing now
   vs. after a rebrand.)

Do not proceed to 4A-1 until I've answered. This is a deliberate stop, not a formality —
4A-5 later in this phase depends directly on the answer to question 1.
```

---

## 4A-1 — donationCamps model + repository

```
Read @CLAUDE.md @docs/DATA_MODEL.md

Task 4A-1: Add a donationCamps collection to docs/DATA_MODEL.md, then build
lib/data/models/donation_camp_model.dart and lib/data/repositories/donation_camp_repository.dart

This collection doesn't exist in docs/DATA_MODEL.md yet — add it there first:
donationCamps/{campId}: name, description, location (GeoPoint), date (Timestamp),
hostName, createdBy (admin uid)
donationCamps/{campId}/rsvps/{userId}: joinedAt (Timestamp) — subcollection, so we know
who RSVP'd, not just a count

Model + repository following the established pattern (freezed/json_serializable,
admin-gated writes matching partner_repository.dart's approach from 1A-12).
Repository methods: listUpcomingCamps(), getCamp(id), createCamp (admin), rsvp(campId, uid),
cancelRsvp(campId, uid), watchRsvpStatus(campId, uid) (for the detail screen's
"You're going" toggle state), rsvpCount(campId).

State the build plan first. Wait for confirmation.
```

---

## 4A-2 — Camp listing/detail/RSVP screens

```
Read @CLAUDE.md @lib/data/repositories/donation_camp_repository.dart

Task 4A-2: Build lib/features/camps/presentation/camp_listing_screen.dart and
camp_detail_screen.dart

camp_listing_screen.dart: upcoming camps sorted by date, each card shows name, host,
date, distance.

camp_detail_screen.dart: full camp details + RSVP button toggling via
DonationCampRepository.rsvp/cancelRsvp, reflecting live rsvpCount and the current user's
own RSVP state (watchRsvpStatus).

Note: this screen wasn't in docs/SPEC.md's original consumer nav — add an entry point
(e.g. from Home's quick actions, or a new bottom-nav-adjacent link) and document it in
docs/SPEC.md now.

State the build plan first. Wait for confirmation.
```

---

## 4A-3 — Admin: Manage camps screen

```
Read @CLAUDE.md @lib/data/repositories/donation_camp_repository.dart

Task 4A-3: Build lib/features/admin/manage_camps/presentation/manage_camps_screen.dart

Same list + add/edit form pattern as manage_partners_screen.dart (1B-6) and
manage_carousel_screen.dart (3A-2) — reuse that structure rather than inventing a new
admin-list pattern. Fields: name, description, location (map picker), date, hostName.

Add this screen to docs/SPEC.md's Admin section — it wasn't originally listed there since
camps weren't in the original data model.

State the build plan first. Wait for confirmation.
```

---

## 4A-4 — Badges computation + Profile badges screen

```
Read @CLAUDE.md @docs/SPEC.md §Profile @lib/data/repositories/blood_request_repository.dart

Task 4A-4: Build badge computation and lib/features/profile/presentation/badges_screen.dart

Define a small, honest set of rule-based badges computed from real donation data already
in the system — do not fabricate a points system that isn't backed by real records:
- "First donation" — 1+ fulfilled donation
- "5 donations" — 5+ fulfilled donations
- "Top responder" — fast acceptance time on nearby requests (define "fast" as a documented
  threshold, e.g. under 30 minutes from notification to acceptance, and note the exact
  threshold chosen in a code comment)

Implement as a Cloud Function that recomputes/writes an earnedBadges array onto
donorProfiles when a relevant threshold is crossed (e.g. triggered on request status
changing to fulfilled) — a Cloud Function is preferred over pure client-side computation
here specifically because earning a badge should trigger a notification ("You earned a
badge!"), which only the backend can reliably do.

badges_screen.dart: displays earnedBadges, replacing the stub from 3A-5.

State the build plan first. Wait for confirmation.
```

---

## 4A-5 — Direct donor-to-donor requests (conditional)

```
Read @CLAUDE.md §5 @CLAUDE.md §7

Task 4A-5: Direct donor-to-donor requests

STOP: only proceed with this task if 4A-0 confirmed this is explicitly in scope. If it
was not confirmed, or you're unsure, do not write any code for this task — report back
that it's being skipped and why, and treat Phase 4A as complete without it.

If confirmed in scope:
- Even though this is a direct request, it must still route through a partner facility
  per CLAUDE.md §5 — do NOT build a flow that arranges a private meetup between two
  individuals. The "accept" action should direct the donor to a partner bank location,
  consistent with the bank-mediated model used everywhere else in this app.
- Decide whether this reuses BloodRequestModel with an added targetDonorId field, or
  warrants its own collection — base the decision on how much the status lifecycle
  actually differs from a normal request. Document whichever you choose in
  docs/DATA_MODEL.md.
- Reuse the existing verification gate (1A-11/2A-8) — only verified donors can be a valid
  targetDonorId, enforced at the query/repository level, not just in the UI.
- Reuse the report/block feature (2A-9) — must be reachable from this flow too.

If this task is skipped, leave no partial implementation behind — no dead routes, no
unused models, no dormant UI. An incomplete P2P feature sitting in the codebase is worse
than not having it.

State the build plan first (or state clearly that this task is being skipped and why).
Wait for confirmation either way.
```

---

## Phase 4A Gate Check

```
Run the following and report all output:

flutter analyze     # must report 0 issues
flutter test        # must pass

Then manually verify and report:
1. Camps listing is real, admin-manageable, and RSVP-able
2. Badges are computed from real donation history and displayed on Profile
3. Task 4A-5 is either fully implemented per an explicit confirmed go-ahead (routed
   through a partner facility, never peer-to-peer), or entirely absent from the codebase
   — confirm which, and if absent, confirm there's no dormant/partial code left behind
4. docs/DATA_MODEL.md and docs/SPEC.md have been updated for every new collection/screen
   this phase introduced (donationCamps, manage camps screen, camp listing/detail, and
   4A-5's model if built)

Then confirm:
1. All tasks in Phase 4A are checked off in docs/PHASES.md (4A-5 checked off as either
   "done" or "skipped — out of scope", not left blank)
2. Update docs/PHASES.md progress tracker and the total at the bottom of the file

This is the last planned phase. Report PASS or FAIL — if PASS, the app matches the full
scope in docs/SPEC.md. Flag anything that still feels unfinished rather than declaring
the project done by default.
```

# bloodlink — Phase 2A Prompts

Core request flow: matching, notifications, donor verification, education hub.
Requires Phase 1B complete. Copy-paste each prompt as-is into Claude Code. One task per session.

---

## 2A-1 — bloodRequests model + repository

```
Read @CLAUDE.md @docs/DATA_MODEL.md §bloodRequests

Task 2A-1: Build lib/data/models/blood_request_model.dart and
lib/data/repositories/blood_request_repository.dart

Model: freezed + json_serializable matching docs/DATA_MODEL.md §bloodRequests —
requesterId, patientName, bloodGroup, units, hospital, urgencyWindow (enum: 2h/6h/24h/1w),
status (enum: pending/matched/fulfilled/expired/cancelled), matchedPartnerIds (List<String>),
createdAt.

Also add a `location` (GeoPoint) field to the model even though it's not yet in
DATA_MODEL.md's written spec — the matching function (2A-2) needs a request-level location
to rank by distance, and "hospital" as a string alone isn't queryable. Update
docs/DATA_MODEL.md to add this field now, in the same change — don't let the doc drift
from the model.

Repository: createRequest, getRequest(id), watchRequest(id) (stream, for status tracking),
listRequestsForUser(uid). No status-transition method yet — that's 2A-5's
updateRequestStatus callable, not a direct client write (bloodRequests update/delete is
admin-only in the deployed security rules, by design).

Run build_runner after adding annotations.

State the build plan first. Wait for confirmation.
```

---

## 2A-2 — Cloud Function: onRequestCreated

```
Read @CLAUDE.md @docs/FIREBASE_SETUP.md §Cloud Functions @docs/DATA_MODEL.md

Task 2A-2: Build the onRequestCreated Cloud Function

Requirements:
- Firestore-triggered function: bloodRequests/{requestId} onCreate
- Query partners/*/stock/{bloodGroup} where bloodGroup matches the request and
  unitCount > 0
- Rank matches by a combination of distance (request.location vs partner.location) and
  stock level — write a short comment explaining the ranking formula you choose, this
  isn't specified precisely elsewhere so document the decision here
- Write matchedPartnerIds (ranked array of partner IDs) back onto the request document
- Set status: "matched" if at least one partner has stock, otherwise leave "pending"
- Factor the ranking logic into a pure, unit-testable function separate from the Firestore
  trigger wrapper — the trigger itself should be a thin wrapper calling that function

Deploy: firebase deploy --only functions
Test against bloodlink-dev with at least one real request and real partner stock data
before considering this done — do not mark this complete based on successful deploy alone.

State the build plan first. Wait for confirmation.
```

---

## 2A-3 — Request blood form screen

```
Read @CLAUDE.md @docs/SPEC.md §Request blood @lib/data/repositories/blood_request_repository.dart

Task 2A-3: Build lib/features/blood_request/presentation/request_blood_screen.dart

Fields per SPEC.md: Patient name (required), Blood group (dropdown, required), Units
needed (numeric stepper, min 1), Urgency (dropdown: Within 2 hours / 6 hours / 24 hours /
a week), Hospital/location (text + map picker, must also capture a GeoPoint for the
model's location field from 2A-1).

On submit: BloodRequestRepository.createRequest with status: "pending" — navigate to the
matched banks results screen (2A-4) immediately after, showing a loading state while
waiting for onRequestCreated (2A-2) to populate matchedPartnerIds (this will take a moment
since it's an async trigger — do not show an empty "no matches" state during this window,
show a distinct loading/matching state).

State the build plan first. Wait for confirmation.
```

---

## 2A-4 — Matched banks results screen

```
Read @CLAUDE.md @docs/SPEC.md §Request blood @lib/data/repositories/blood_request_repository.dart @lib/data/repositories/partner_repository.dart

Task 2A-4: Build lib/features/blood_request/presentation/matched_banks_screen.dart

Requirements:
- Watch the request via BloodRequestRepository.watchRequest so this screen updates live
  once onRequestCreated (2A-2) populates matchedPartnerIds
- Three states: loading/matching (status still "pending", no matches yet), matched
  (status "matched", render each matched partner via PartnerRepository.getPartner —
  show name, distance, stock for the requested blood group), no-matches-found (status
  stays "pending" after a reasonable wait — show a clear message, not a spinner forever)
- Each matched bank row navigates to bank_profile_screen (1B-9) on tap

State the build plan first. Wait for confirmation.
```

---

## 2A-5 — Status tracking + updateRequestStatus function

```
Read @CLAUDE.md @docs/SPEC.md §Request blood @docs/FIREBASE_SETUP.md

Task 2A-5: Build the updateRequestStatus Cloud Function (callable) and
lib/features/blood_request/presentation/request_status_screen.dart

Cloud Function (callable, not Firestore-triggered):
- Input: requestId, newStatus ("fulfilled" | "cancelled")
- Validate the caller's uid matches the request's requesterId before applying the change
  — reject otherwise. This exists specifically because bloodRequests update/delete is
  admin-only in Firestore rules; this function runs with elevated privileges but enforces
  ownership itself, so a requester can still manage their own request without loosening
  the rules file.
- Deploy: firebase deploy --only functions

request_status_screen.dart:
- List of the current user's requests (BloodRequestRepository.listRequestsForUser) with
  status badges (AppBadge, 1A-5)
- Per-request actions: "Mark fulfilled" / "Cancel" buttons calling the callable function
  above — only shown for the request's own owner, and only when status is pending/matched
  (not already fulfilled/expired/cancelled)

State the build plan first. Wait for confirmation.
```

---

## 2A-6 — FCM token setup

```
Read @CLAUDE.md @lib/data/repositories/user_repository.dart

Task 2A-6: Wire Firebase Cloud Messaging token storage

Requirements:
- Request notification permission at donor profile setup completion (1B-4), not on first
  app launch — the user should have a reason to grant it by that point
- On permission granted, get the FCM token and store it via
  UserRepository.updateFcmToken (already scaffolded in 1A-10/1A-7)
- Handle token refresh (FCM tokens can rotate) — listen for onTokenRefresh and update
  the stored token
- Set up a basic foreground message handler (show an in-app banner/snackbar) and a
  background/terminated tap handler that deep-links via the router (1A-6) — the actual
  navigation-by-type logic can be minimal here, it gets built out properly once 2A-7's
  notification types exist

State the build plan first. Wait for confirmation.
```

---

## 2A-7 — Cloud Functions: match + status notifications

```
Read @CLAUDE.md @docs/DATA_MODEL.md §notifications @docs/FIREBASE_SETUP.md

Task 2A-7: Extend onRequestCreated (2A-2) and add a status-change notification function

Requirements:
- Extend 2A-2's onRequestCreated: after writing matchedPartnerIds, query donorProfiles
  where verificationStatus == "verified" and bloodGroup matches, within each donor's own
  optInRadiusKm of the request location — for each match, write a notifications doc
  (type: "request_nearby") and send via FCM using their stored fcmToken (2A-6)
- Add onRequestStatusChanged (Firestore onUpdate trigger on bloodRequests, or called from
  within 2A-5's callable directly — pick whichever avoids a redundant second trigger) that
  notifies the requester (type: "request_status") when status changes
- Deploy and test both against bloodlink-dev with real data — confirm a real device/emulator
  actually receives the push, don't just confirm the Firestore doc was written

State the build plan first. Wait for confirmation.
```

---

## 2A-8 — Donor verification flow

```
Read @CLAUDE.md @docs/SPEC.md §Donor directory @docs/DATA_MODEL.md §donorProfiles

Task 2A-8: Build lib/features/donor_profile/presentation/donor_verification_screen.dart

Requirements:
- ID upload (image picker → Cloud Storage), sets donorProfiles.verificationStatus to
  "pending"
- Since there's no separate reviewer role in this app (Admin does everything per
  CLAUDE.md §2), the review step belongs in the Admin shell — add a minimal
  "Verify donors" list to the admin nav (list of pending donors, approve/reject buttons
  writing verificationStatus to "verified"/"unverified"). Note this as an addition to
  docs/SPEC.md's Admin section since it wasn't originally listed there.
- Confirm 1A-11's queryVerifiedDonors filter is still correctly excluding non-"verified"
  donors after this flow exists — this is the point where that filter actually gets
  exercised with real pending/rejected data, treat it as a regression check

State the build plan first. Wait for confirmation.
```

---

## 2A-9 — Report/block feature

```
Read @CLAUDE.md @docs/DATA_MODEL.md §reports

Task 2A-9: Build lib/data/repositories/report_repository.dart and a reusable
report_button.dart widget

report_repository.dart:
- createReport(reporterId, targetType, targetId, reason): Future<void>
- listOpenReports(): Future<List<ReportModel>> — for the admin moderation screen (Phase 3A)
- Add the matching ReportModel to lib/data/models/ (freezed + json_serializable) if not
  already present

report_button.dart:
- Small reusable "Report" button + reason-input dialog, usable from a request detail
  screen or a donor profile card
- Any signed-in user can create a report (matches the security rules — read/update is
  admin-only)

State the build plan first. Wait for confirmation.
```

---

## 2A-10 — educationArticles model + repository + seed content

```
Read @CLAUDE.md @docs/DATA_MODEL.md §educationArticles @CLAUDE.md §5

Task 2A-10: Build lib/data/models/education_article_model.dart,
lib/data/repositories/education_article_repository.dart, and seed 6 articles

Model + repository: standard freezed/json_serializable + CRUD pattern, matching prior
tasks. category enum: basics | eligibility | guidance | faq.

Seed exactly these 6 articles (write via a one-off admin script or directly through
Firestore console/emulator — do not build a UI for this, that's 2A-11):
1. What is blood? (basics)
2. Blood types & compatibility — who can donate to whom (basics)
3. Who can donate? — eligibility basics (eligibility)
4. Do's and don'ts before donating (guidance)
5. Do's and don'ts after donating (guidance)
6. Frequently asked questions (faq)

Write content in plain, non-clinical language. Per CLAUDE.md §5: do not phrase anything as
a medical eligibility determination — this is informational content, not a clearance.

State the build plan first. Wait for confirmation.
```

---

## 2A-11 — Education hub screens

```
Read @CLAUDE.md @docs/SPEC.md §Education hub @lib/data/repositories/education_article_repository.dart

Task 2A-11: Build lib/features/education_hub/presentation/education_hub_screen.dart and
article_detail_screen.dart

education_hub_screen.dart: article list, grouped/filterable by category, ordered by
displayOrder.

article_detail_screen.dart: title + body — plain text rendering is fine, no need for a
rich markdown renderer in v1.

State the build plan first. Wait for confirmation.
```

---

## Phase 2A Gate Check

```
Run the following and report all output:

flutter analyze     # must report 0 issues
flutter test        # must pass

Then manually verify and report:
1. A real request submitted through the app gets real ranked matches from real partner
   stock, not a mocked ranking
2. A verified donor within range and matching blood group receives an actual push
   notification for a new nearby request. **Live push verification is partial as of
   2A-6 — do not treat this item as fully satisfied by default; state explicitly what
   was (re-)confirmed for this Gate Check and what's still outstanding.** Per
   CLAUDE.md §7: Android foreground and background (backgrounded, not force-stopped)
   delivery + tap-through were confirmed live via real FCM sends; Android true
   cold-start/terminated delivery was not (`adb shell am force-stop` blocks FCM's
   wake-up broadcast entirely — it's not a valid stand-in for a user swiping the app
   away, and no working alternative was found via ADB in that session); iOS is
   entirely unverified (no physical device, and `simctl push` doesn't exercise real
   FCM→APNs delivery). Confirm this status is still current before signing off, and
   don't silently report the phase as fully passing if these gaps remain unresolved.
3. Request status transitions are restricted to the request's own owner, enforced
   server-side (test by attempting a transition as a different user — it should fail)
4. Unverified donors never appear in donor directory queries
5. Education Hub has all 6 seeded articles, viewable in the app

Then confirm:
1. All 11 Phase 2A tasks are checked off in docs/PHASES.md
2. CLAUDE.md "Active Task" now points to 3A-1
3. Update docs/PHASES.md progress tracker: Phase 2A [ 11 / 11 tasks ] 100%, and update the
   total at the bottom of the file

Report PASS or FAIL with details on any failure before I proceed to Phase 3A.
```

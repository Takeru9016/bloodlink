# FIREBASE_SETUP

## Services
- **Firestore** — primary data store, schema in `docs/DATA_MODEL.md`
- **Firebase Auth** — email/password + Google OAuth
- **Cloud Storage** — banner carousel images, education hub images
- **Cloud Functions** — request-matching logic, state-transition validation, notification triggers
- **Firebase Cloud Messaging** — push notifications

## Environments
Two Firebase projects minimum: `bloodlink-dev` and `bloodlink-prod`. Never develop or test against prod data. `flutterfire configure` should point local dev at `bloodlink-dev`.

## Security rules
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function isSignedIn() { return request.auth != null; }
    function isAdmin() {
      return isSignedIn() &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.roles.hasAny(['admin']);
    }
    function isOwner(userId) { return isSignedIn() && request.auth.uid == userId; }

    match /users/{userId} {
      allow read: if isSignedIn();
      allow write: if isOwner(userId) || isAdmin();
    }

    match /donorProfiles/{userId} {
      allow read: if isSignedIn();
      allow write: if isOwner(userId) || isAdmin();
    }

    match /bloodRequests/{requestId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update, delete: if isAdmin(); // status transitions go through Cloud Functions in practice
    }

    match /partners/{partnerId} {
      allow read: if true; // public-readable, no auth required to browse banks
      allow write: if isAdmin();

      match /stock/{bloodGroup} {
        allow read: if true;
        allow write: if isAdmin();
      }
    }

    match /bannerItems/{bannerId} {
      allow read: if true;
      allow write: if isAdmin();
    }

    match /educationArticles/{articleId} {
      allow read: if true;
      allow write: if isAdmin();
    }

    match /notifications/{notificationId} {
      allow read, update: if isSignedIn() && resource.data.userId == request.auth.uid;
      allow write: if isAdmin(); // creation typically via Cloud Function
    }

    match /reports/{reportId} {
      allow create: if isSignedIn();
      allow read, update: if isAdmin();
    }
  }
}
```
Deploy with `firebase deploy --only firestore:rules` after any change. Do not hand-edit rules in the Firebase console except for a genuine emergency fix — the rules file in the repo is the source of truth.

## Storage rules
Donor-verification (2A-8) and banner-carousel (3A-1) paths are covered. Education-hub image uploads (`docs/SPEC.md` "Manage education hub") are still unbuilt and have no rules yet — see `CLAUDE.md` §7 open items, add them when that admin upload flow lands.

Rules live in `storage.rules` at the repo root (wired into `firebase.json` under `"storage"`), same source-of-truth convention as `firestore.rules` — this doc is a mirror, not the canonical copy. `firebase.json` had no `"storage"` key until 3A-1; the `firebase deploy --only storage` command documented here since 2A-8 could not actually have worked before that was added.
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    function isSignedIn() { return request.auth != null; }
    // Storage Rules' cross-service firestore.get() is broken on this
    // project (root cause unknown — see the writeup below), so admin here
    // is a custom claim, set manually via functions/scripts/setAdminClaims.js
    // — NOT the Firestore roles array that Firestore rules' isAdmin() still uses.
    function isAdmin() {
      return isSignedIn() && request.auth.token.admin == true;
    }
    function isOwner(userId) { return isSignedIn() && request.auth.uid == userId; }

    // ID verification photos — more sensitive than blood group/history (CLAUDE.md §5),
    // readable/writable only by the donor themself or an admin reviewing the queue.
    match /donorVerification/{userId}/{fileName} {
      allow read, write: if isOwner(userId) || isAdmin();
    }

    // Home banner carousel images — public-readable like bannerItems/* in
    // Firestore, curated only by admins (docs/SPEC.md "Manage home carousel").
    match /bannerImages/{fileName} {
      allow read: if true;
      allow write: if isAdmin();
    }
  }
}
```
Deploy with `firebase deploy --only storage`. **Resolved 3A-1**: Storage is now provisioned on `bloodlink-dev-wt` (bucket `bloodlink-dev-wt.firebasestorage.app`, region-matched to Firestore) and these rules are deployed and live.

### `isAdmin()` cross-service bug — worked around via custom claims (3A-1)

**Original bug, confirmed live on this project — `isAdmin()`'s cross-service `firestore.get()` call does not work in Storage Rules.** Verified end-to-end on a real device against the real deployed bucket (not assumed): a test account's `users/{uid}.roles` array was confirmed (on-screen, via a live Firestore read) to contain `admin`, yet every write gated by the old `firestore.get(/databases/(default)/documents/users/$(request.auth.uid)).data.roles...`-based `isAdmin()` was denied with a real HTTP 403 from the Storage backend. Isolated the exact failure point by swapping in variants one at a time and diffing the bucket's object list before/after each real upload attempt: `isSignedIn()` alone → succeeds; `firestore.get(...).data.roles.size() > 0` → **fails**; `firestore.get(...).data.roles.hasAny(['donor'])` → **fails**; `'admin' in firestore.get(...).data.roles` → **fails**; even bare `firestore.exists(/databases/(default)/documents/users/$(request.auth.uid))` with no `.data` access → **fails**. `isOwner(userId)`-gated writes work fine and are unaffected, since they never call `firestore.get()`.

**First proposed root cause was WRONG — corrected rather than left standing.** An earlier pass concluded the missing piece was a `firebaserules.firestoreServiceAgent` IAM role. **That role name does not exist** — checked directly against Google's own IAM roles reference for `firebaserules` (`.admin`, `.system`, `.viewer` are the only three). A human then ran `firebase deploy --only storage` interactively, answering "yes" to the cross-service prompt — the failure persisted, re-confirmed with the same before/after rigor as the original finding. Direct inspection of the project's IAM policy confirmed `roles/firebaserules.system` was already bound before any of this started. So the interactive deploy never had anything to fix at the IAM layer.

**Status: true root cause is still unknown — genuinely unexplained, not just unfixed.** Two independent rigorous investigation rounds (before/after `gcloud storage ls` object-count diffs around real upload attempts, every operator tested) confirm the cross-service `firestore.get()`/`firestore.exists()` bridge from Storage Rules reliably fails closed on this project, with the correct IAM role already present. This doesn't match any documented Firebase limitation found via research. A genuine Firebase support ticket (or a `firebase-tools`/`firebase-js-sdk` GitHub issue for this exact symptom) is still the right next step if the underlying bridge itself ever needs fixing — but that's no longer blocking, per below.

**Resolved for Storage rules (3A-1), via custom claims — not a fix for the underlying bridge.** Since there are only ever 2 admin accounts (CLAUDE.md §2), a Cloud Function auto-sync trigger was overkill. Instead: `functions/scripts/setAdminClaims.js` is a one-time, manually-run Node script (using `firebase-admin` against the real `bloodlink-dev-wt` project, not the emulator) that sets the Firebase Auth custom claim `admin: true` on a given uid. Storage Rules' `isAdmin()` now checks `request.auth.token.admin == true` instead of the broken Firestore lookup. **Firestore rules are unchanged** — `firestore.rules`' `isAdmin()` still uses the Firestore `roles` array lookup, which was never broken; only the Storage-side check depended on the cross-service bridge.

Re-verified with the same rigorous before/after methodology as the original bug report: ran `setAdminClaims.js` against the test admin account, redeployed `storage.rules`, confirmed via `gcloud storage ls` that `bannerImages/` was empty, triggered a real admin upload through the app on a real device, confirmed via `gcloud storage ls` that the object now existed (`bannerImages/debug_claim_test.jpg`), then cleaned it up. **Confirmed working — admin writes to `bannerImages/*` now succeed.**

**If a 3rd admin is ever added, or an existing admin account is replaced, `functions/scripts/setAdminClaims.js` must be re-run for that account's uid** (`cd functions && node scripts/setAdminClaims.js <uid>`), or Storage writes will silently fail for them — Firestore-backed admin checks are unaffected, since those don't depend on this claim. There is no auto-sync; this is a manual step tied to admin provisioning.

**3A-2 (Admin: Manage home carousel screen) is now genuinely unblocked.**

## Cloud Functions (build these in Stage 2, per prompts/stage-2-core-request-flow.md)
- `onRequestCreated` — runs bank-matching (rank partner banks by requested blood group stock + distance), writes `matchedPartnerIds` back onto the request document
- `onStockUpdated` — defense-in-depth timestamp/attribution check alongside security rules
- `onReportCreated` — notifies admin(s) via FCM

## Cost monitoring
Free tier ("Spark plan") covers early-stage usage. Set up budget alerts in the Firebase console before real users are on the app — this is a free/non-profit product with no revenue buffer.

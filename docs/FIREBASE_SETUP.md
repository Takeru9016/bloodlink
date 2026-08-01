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
Only the donor-verification path is covered so far (2A-8). Banner-carousel and education-hub image uploads (`docs/SPEC.md` "Manage home carousel" / "Manage education hub") are still unbuilt and have no rules yet — see `CLAUDE.md` §7 open items, add them when those admin upload flows land.
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    function isSignedIn() { return request.auth != null; }
    function isAdmin() {
      return isSignedIn() &&
        firestore.get(/databases/(default)/documents/users/$(request.auth.uid)).data.roles.hasAny(['admin']);
    }
    function isOwner(userId) { return isSignedIn() && request.auth.uid == userId; }

    // ID verification photos — more sensitive than blood group/history (CLAUDE.md §5),
    // readable/writable only by the donor themself or an admin reviewing the queue.
    match /donorVerification/{userId}/{fileName} {
      allow read, write: if isOwner(userId) || isAdmin();
    }
  }
}
```
Deploy with `firebase deploy --only storage`.

## Cloud Functions (build these in Stage 2, per prompts/stage-2-core-request-flow.md)
- `onRequestCreated` — runs bank-matching (rank partner banks by requested blood group stock + distance), writes `matchedPartnerIds` back onto the request document
- `onStockUpdated` — defense-in-depth timestamp/attribution check alongside security rules
- `onReportCreated` — notifies admin(s) via FCM

## Cost monitoring
Free tier ("Spark plan") covers early-stage usage. Set up budget alerts in the Firebase console before real users are on the app — this is a free/non-profit product with no revenue buffer.

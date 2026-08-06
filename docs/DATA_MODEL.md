# DATA_MODEL — Firestore schema

Source of truth for every collection. Update this file first when the schema needs to change, then update code — not the other way around. If code and this file disagree, this file wins until someone deliberately updates both.

## `users/{userId}`
```
name: string
email: string
phone: string | null
roles: array<"donor" | "requester" | "admin">
location: geopoint | null       // null until device location is captured
city: string | null             // manual-entry fallback when location permission is denied; mutually exclusive with location
createdAt: timestamp
fcmToken: string | null          // current device's FCM registration token (2A-6); overwritten on refresh, cleared on a dead-token push failure (4B-7)
```

## `donorProfiles/{userId}`
```
bloodGroup: string             // "A+" | "A-" | "B+" | "B-" | "O+" | "O-" | "AB+" | "AB-"
dob: timestamp
lastDonationDate: timestamp | null
verificationStatus: "unverified" | "pending" | "verified"
optInRadiusKm: number
verificationDocUrl: string | null   // Cloud Storage download URL of uploaded ID (2A-8); overwritten in place on resubmission, never accumulates history
verifiedBy: string | null           // ref users, admin only — who last approved/rejected (2A-8)
verifiedAt: timestamp | null        // 2A-8
```

## `bloodRequests/{requestId}`
```
requesterId: string            // ref users
patientName: string
bloodGroup: string
units: number
hospital: string
location: geopoint             // request-level location for distance-ranked matching (2A-2)
urgencyWindow: "2h" | "6h" | "24h" | "1w"
status: "pending" | "matched" | "fulfilled" | "expired" | "cancelled"
matchedPartnerIds: array<string>   // written by onRequestCreated Cloud Function
createdAt: timestamp
```

## `partners/{partnerId}`
```
name: string
address: string
location: geopoint
phone: string
verificationStatus: "pending" | "verified"
updatedBy: string               // ref users, admin only
updatedAt: timestamp
// No login of its own — see CLAUDE.md non-negotiable decisions
```

## `partners/{partnerId}/stock/{bloodGroup}`
```
unitCount: number
lastUpdatedBy: string          // ref users, admin only
lastUpdatedAt: timestamp
```
One document per blood group per partner (8 documents per partner: A+, A-, B+, B-, O+, O-, AB+, AB-).

## `bannerItems/{bannerId}`
```
imageUrl: string                // Cloud Storage download URL
linkedPartnerId: string | null  // ref partners
displayOrder: number
active: boolean
createdBy: string               // ref users, admin only, set once at creation
updatedBy: string                // ref users, admin only, last writer
updatedAt: timestamp
```

## `educationArticles/{articleId}`
```
title: string
body: string
category: "basics" | "eligibility" | "guidance" | "faq"
displayOrder: number
imageUrl: string | null          // Cloud Storage download URL (4B-3); optional, articles are text-primary
updatedBy: string                // ref users, admin only
updatedAt: timestamp
```

## `helpFaqs/{faqId}`
```
question: string
answer: string
displayOrder: number
updatedBy: string                // ref users, admin only
updatedAt: timestamp
```
Backs the consumer Help & support screen (4B-6). Deliberately separate from `educationArticles`' `"faq"` category — that category is donation/health FAQ content shown in Education Hub, this is app-usage FAQ content (how matching works, verification, notifications) shown in Help & support. Admin-managed via a dedicated "Manage help & support" screen, same list+form pattern as Manage education hub minus the image/category fields.

## `appConfig/support`
```
email: string
updatedBy: string                // ref users, admin only
updatedAt: timestamp
```
Singleton doc (not a collection — there's only ever one support contact for the app), also backing Help & support (4B-6). Editable from the same "Manage help & support" admin screen as `helpFaqs`. If this doc doesn't exist yet, the consumer screen shows an honest "not set up yet" state rather than falling back to a hardcoded email — see `CLAUDE.md` line 3 on not baking a placeholder brand identity into generated copy.

## `notifications/{notificationId}`
```
userId: string                   // ref users
type: string                     // "request_nearby" | "request_status" | "stock_alert" | ...
payload: map
readStatus: boolean
createdAt: timestamp
```

## `reports/{reportId}`
```
reporterId: string               // ref users
targetType: "request" | "donor"
targetId: string
reason: string
status: "open" | "reviewed" | "dismissed"
createdAt: timestamp
```

## `donationCamps/{campId}`
```
name: string
description: string
location: geopoint
date: timestamp
hostName: string
createdBy: string                // ref users, admin only — set once, at creation, never overwritten
updatedBy: string                // ref users, admin only — same uid as createdBy at creation; updated by 4A-3's edit flow thereafter
updatedAt: timestamp
```
Follows `partners`' attribution pattern (CLAUDE.md §5) from the start, rather than repeating the `createdBy`-only gap already flagged for `bannerItems` in CLAUDE.md §7.

## `donationCamps/{campId}/rsvps/{userId}`
```
joinedAt: timestamp
```
Subcollection so RSVPs are attributable per-user, not just a count. Writable by the RSVP'ing user themselves (not admin-gated) — `userId` (doc ID) must equal the writer's own uid.

## Security rules — non-negotiable, see docs/FIREBASE_SETUP.md for the actual rules file
- Only `admin` may write to `partners/*`, `partners/*/stock/*`, `bannerItems/*`, `educationArticles/*`, `donationCamps/*`, `helpFaqs/*`, `appConfig/*`.
- A `donor`/`requester` may only write their own `users/{uid}` and `donorProfiles/{uid}`.
- `donationCamps/*/rsvps/{userId}` is writable only by the user matching `{userId}` — self-RSVP, not admin-gated.
- `bloodRequests` creatable by the `requesterId` only; status transitions beyond creation should go through a Cloud Function, not a raw client write, so state transitions can be validated server-side.

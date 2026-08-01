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
fcmToken: string | null          // current device's FCM registration token (2A-6); overwritten on refresh, never cleared on send failure (2A-7)
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
createdBy: string               // ref users, admin only
updatedAt: timestamp
```

## `educationArticles/{articleId}`
```
title: string
body: string
category: "basics" | "eligibility" | "guidance" | "faq"
displayOrder: number
updatedBy: string                // ref users, admin only
updatedAt: timestamp
```

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

## Security rules — non-negotiable, see docs/FIREBASE_SETUP.md for the actual rules file
- Only `admin` may write to `partners/*`, `partners/*/stock/*`, `bannerItems/*`, `educationArticles/*`.
- A `donor`/`requester` may only write their own `users/{uid}` and `donorProfiles/{uid}`.
- `bloodRequests` creatable by the `requesterId` only; status transitions beyond creation should go through a Cloud Function, not a raw client write, so state transitions can be validated server-side.

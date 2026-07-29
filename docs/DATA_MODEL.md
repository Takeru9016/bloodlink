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
```

## `donorProfiles/{userId}`
```
bloodGroup: string             // "A+" | "A-" | "B+" | "B-" | "O+" | "O-" | "AB+" | "AB-"
dob: timestamp
lastDonationDate: timestamp | null
verificationStatus: "unverified" | "pending" | "verified"
optInRadiusKm: number
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
```

## Security rules — non-negotiable, see docs/FIREBASE_SETUP.md for the actual rules file
- Only `admin` may write to `partners/*`, `partners/*/stock/*`, `bannerItems/*`, `educationArticles/*`.
- A `donor`/`requester` may only write their own `users/{uid}` and `donorProfiles/{uid}`.
- `bloodRequests` creatable by the `requesterId` only; status transitions beyond creation should go through a Cloud Function, not a raw client write, so state transitions can be validated server-side.

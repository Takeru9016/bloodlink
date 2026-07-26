# SPEC — screen-by-screen functional spec

Every screen below is the contract for that screen. If you're building a screen and something isn't specified here, stop and ask rather than inventing behavior — that's the whole point of this file existing.

---

## Onboarding & Auth

### Onboarding (3 screens)
- Skippable at any point (top-right "Skip" → jumps straight to Sign up)
- Screen 1: "Find blood, save lives" — intro to the app's purpose
- Screen 2: "Need blood? Just a tap away" — intro to requesting
- Screen 3: "Secure blood for surgeries & emergencies" — intro to booking from trusted banks
- Pagination dots at bottom, swipeable
- Last screen's primary action goes to Sign up

### Sign up
Fields: Full name (required), Email (required, validated format), Password (required, min 8 chars). Also: "Continue with Google" button (Firebase Auth Google provider).
On submit: create Firebase Auth user, create `users/{uid}` doc with `roles: []` (role chosen next), navigate to role selection / donor profile setup.

### Sign in
Fields: Email, Password. Plus "Continue with Google". "Forgot password" link → Firebase Auth password reset email flow.

### Donor profile setup
Only shown if the user opts into the `donor` role (can be skipped if they only want `requester`). Fields: Blood group (dropdown: A+, A-, B+, B-, O+, O-, AB+, AB-), Date of birth (date picker, must be 18+ — do not hardcode a different minimum without checking `CLAUDE.md` open items), City/location (uses device location permission, falls back to manual text entry), Last donation date (optional, date picker, nullable).
Writes to `donorProfiles/{uid}`.

---

## Consumer app (Donor / Requester)

### Home
- Top bar: menu icon (opens drawer/settings), "Home" title, notification bell (badge if unread)
- Trusted-partner banner carousel: auto-rotating, reads active `bannerItems` ordered by `displayOrder`. Tap → full-screen image viewer (modal, swipeable if multiple, pinch-to-zoom). If `linkedPartnerId` is set, viewer has a "View bank" button that navigates to that partner's Bank profile screen.
- Quick actions row: "Request blood" (→ Blood request form), "Find bank" (→ Bank locator), "Donor list" (→ Donor directory)
- "Trusted partners" section: grid of partner logos/cards (separate from the carousel — this is a static trust signal, carousel is the promotional rotation)
- Bottom nav: Home, Request, Banks, Donors, Profile (5 items, always visible on consumer screens)

### Request blood
Form fields: Patient name (required), Blood group (dropdown, required), Units needed (numeric stepper, required, min 1), Urgency (dropdown: "Within 2 hours" / "Within 6 hours" / "Within 24 hours" / "Within a week"), Hospital/location (text + map picker).
On submit: write to `bloodRequests` with `status: "pending"`, trigger matching (see `docs/FIREBASE_SETUP.md` Cloud Functions plan — `onRequestCreated`). Navigate to a results screen showing ranked partner banks (distance + stock for the requested blood group). From there, requester can mark the request fulfilled or cancel it. A status-tracking view shows the current state: pending → matched → fulfilled/expired/cancelled.

### Bank locator
List/map toggle. List: search bar (name or location), rows show bank name, distance, address snippet. Map: pins for each partner bank, tap pin → bottom sheet with the same summary, tap through to full profile.
**Bank profile**: bank name (hero header), location, phone, per-blood-group stock grid (8 cells: A+/A-/B+/B-/O+/O-/AB+/AB-, each showing unit count), "stock last updated" timestamp (source: `partners/{id}/stock/{group}.lastUpdatedAt` — show the most recent across all groups), Continue/Contact button.

### Donor directory
List of verified donors only (`donorProfiles.verificationStatus == "verified"`) — never show unverified donors here, that's a trust & safety requirement, not a nice-to-have. Filter by blood group, distance. Each row: avatar, name, distance, rating (if implemented), blood group badge.

### Education hub
Article list grouped/filterable by category (`basics`, `eligibility`, `guidance`, `faq`), reading from `educationArticles` ordered by `displayOrder`. Tap → article detail (title + body, simple rich text or markdown rendering — keep it plain, this is not a CMS-grade renderer). Content is written for a general public audience — if you're asked to generate placeholder article copy, keep language plain and non-clinical, and do not present it as medical advice (see `CLAUDE.md` Section 5).

### Notifications
Grouped "Today" / "Earlier". Each row: icon/dot, title, subtitle, optional inline action button (e.g. "Accept" for an incoming donor request notification). Tapping a notification navigates to the relevant screen (request detail, bank profile, etc. depending on `type`).

### Profile
Avatar, name, blood group. Stats row: lives saved (count of fulfilled donations tied to this donor), donations count, rating (if implemented — can be a static placeholder until rating logic exists, but label it honestly, don't fake data). Menu: Donation history, Badges, Settings, Help & support, Log out.

---

## Admin (single role, in-app, gated navigation — completely separate nav shell from consumer screens)

### Manage partners
List of partner banks with a verification-status badge (Verified/Pending). "+ Add new partner" → form: name, address, phone, geo-location (map picker). Edit existing → same form pre-filled, plus a verify/deactivate toggle.

### Update stock
Select partner (dropdown or search), then an 8-cell grid (A+/A-/B+/B-/O+/O-/AB+/AB-) with numeric inputs, "Save stock update" button. On save: write each changed `partners/{id}/stock/{group}` doc with `unitCount`, `lastUpdatedBy: <admin uid>`, `lastUpdatedAt: serverTimestamp()`. This is the screen `CLAUDE.md`'s "every admin write is attributed" rule matters most for — do not skip the attribution fields here.

### Manage home carousel
List of banner items with active/inactive badge. "+ Upload banner" → image picker (uploads to Cloud Storage) + optional "link to partner" dropdown + display order. Toggle active/inactive per item without deleting it.

### Manage education hub
List of articles with an "Edit" action per row. "+ New article" → title, category dropdown, body (plain text editor is fine, no need for rich formatting UI in v1).

### Moderation
Reports queue: each row shows what was reported (request or donor), the reason, a "Review" action. Reviewing should let the admin mark the report reviewed/dismissed and, if warranted, take action on the underlying request/donor (e.g. deactivate a donor profile) — but building the actual punitive actions can wait until this screen's basic queue view works.

---

## Explicitly out of scope until told otherwise
- Direct donor-to-donor "send request" (see `CLAUDE.md` Section 5 and Section 7)
- Any per-partner login
- Web or desktop client of any kind

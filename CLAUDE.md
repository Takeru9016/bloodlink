# bloodlink — Claude Code project master file

Placeholder app name. Find-and-replace "bloodlink" everywhere (package name, org, doc titles) once the client confirms a brand name — PRD v0.3, Section 13, still open. Do not treat "bloodlink" as final in any generated copy, comments, or asset names.

Read this file in full before doing anything in this repo. It is the persistent memory across Claude Code sessions — treat it as more authoritative than your own assumptions about the project.

**Active Task: 2A-5**
Update this line after every completed task (see `docs/PHASES.md` for the full tracker). Prompts are run one at a time, in order, from `prompts/phase-*.md` — do not skip ahead.

---

## 1. What this project is

A free, non-profit blood donation platform: a single Flutter app (iOS + Android) connecting three kinds of users — Donors, Requesters, and one internal Admin role — with partner blood banks/hospitals. There is no separate web app and no per-partner login. Full product rationale lives in the PRD (not in this repo by default — ask the user for it if you need context beyond what's summarized in `docs/SPEC.md`).

Core loop: a Requester submits a blood request → the app matches it against real-time stock at partnered blood banks → the Requester is routed to a bank, not to an unverified individual. Donors separately get notified of nearby need and can track their own donation history. Admin (client's internal team) is the only role that can create/edit partner banks, update stock, curate the home screen's trusted-partner banner carousel, and manage the Education Hub content.

## 2. Roles — exactly three, don't add a fourth without being told

| Role | Can do |
|---|---|
| `donor` | Own profile, donation history, view requests near them, respond to requests |
| `requester` | Submit blood requests, track status, view bank locator |
| `admin` | Everything: manage partners, stock, banners, education content, moderation. Provisioned internally — never via self-service signup. |

A single user can hold both `donor` and `requester` roles. `admin` is mutually exclusive with self-service signup — there is no UI path for a regular user to become admin.

## 3. Tech stack — confirmed, do not suggest alternatives

- **Flutter**, single codebase, iOS + Android only (no web/desktop targets)
- **State management: Riverpod** (use code generation — `riverpod_generator` — not manual `Provider` boilerplate)
- **Backend: Firebase** — Firestore, Firebase Auth, Cloud Storage, Cloud Functions, Firebase Cloud Messaging
- **Maps: `google_maps_flutter` + `geolocator`**
- **Models: `freezed` + `json_serializable`** for every Firestore-backed data class
- **Lint: `flutter analyze` must be clean before any commit is considered done**

If you (Claude Code) find yourself about to suggest Provider, GetX, Bloc, a custom REST backend, or a web admin panel — stop. That is not this project's stack. Ask before deviating.

## 4. Repo structure (create this exact shape in Stage 1, don't improvise a different layout)

```
lib/
  main.dart
  core/
    theme/               # design tokens from docs/DESIGN_SYSTEM.md as ThemeData
    router/               # go_router setup, role-gated routes
    constants/
  data/
    models/               # freezed models, one file per Firestore collection
    repositories/         # all Firestore/Storage/Functions access goes through here
  features/
    auth/
      presentation/        # screens
      application/         # riverpod providers/controllers
    onboarding/
    donor_profile/
    home/
    blood_request/
    bank_locator/
    donor_directory/
    education_hub/
    notifications/
    profile/
    admin/
      manage_partners/
      update_stock/
      manage_carousel/
      manage_education_hub/
      moderation/
  shared/
    widgets/              # reusable buttons, inputs, cards per DESIGN_SYSTEM.md
test/
  (mirror lib/ structure)
```

Every screen lives under `features/<feature>/presentation/`. Every screen's state lives under `features/<feature>/application/`. Nothing reaches into Firestore directly from a widget — always through `data/repositories/`.

## 5. Non-negotiable product decisions

These came from real discussion, not defaults — do not silently revert them:

- **Bank-mediated matching only.** A blood request matches against partner bank stock. There is no "send request directly to an individual donor" feature unless you're explicitly told this Stage 4 item has been confirmed in scope (it wasn't, as of this file being written).
- **No per-partner login.** Partner banks/hospitals never get their own account. All partner data — profile, stock — is entered by Admin on their behalf. If you find yourself building a "partner sign up" flow, stop.
- **Every Admin write is timestamped and attributed.** Stock edits, partner changes, banner changes, education content changes — every one needs `updatedBy` (the acting admin's uid) and `updatedAt`. This is the only audit trail in the system; do not skip it to save a field.
- **Education Hub content is informational, never clinical.** Do not phrase anything as a medical eligibility determination. If a screen implies "you are cleared to donate," that's a bug — eligibility is self-reported, and real clearance happens at the bank.
- **Sensitive data hygiene.** Blood group and donation history never get logged in plaintext, never get sent to crash/analytics tools unredacted. Check any `print()`, logging, or crash-reporting integration you add against this.

## 6. How to use this repo across sessions

Work stage by stage using the files in `prompts/`. Each stage prompt is fully self-contained — it can be pasted as a single message and Claude Code should be able to execute it without needing this file re-explained, though reading this file first is still expected. Do not start a later stage until the previous stage's "Definition of done" checklist is actually true, not just "mostly done."

- `prompts/phase-1a-foundation.md`
- `prompts/phase-1b-stage1-screens.md`
- `prompts/phase-2a-request-flow.md`
- `prompts/phase-3a-engagement.md`
- `prompts/phase-4a-extended.md`

Supporting reference docs (read the relevant one before building anything it covers):
- `docs/SPEC.md` — every screen, what it does, who can see it
- `docs/DATA_MODEL.md` — every Firestore collection, every field, types
- `docs/DESIGN_SYSTEM.md` — colors, type, spacing, component shapes
- `docs/FIREBASE_SETUP.md` — security rules, Cloud Functions plan, environments

Slash commands available: `.claude/commands/new-screen.md`, `.claude/commands/new-firestore-model.md` — use these instead of freehanding a new screen/model from scratch, they encode the conventions above.

**After finishing any task's implementation, run `/check` automatically before reporting the task as done** — do not wait to be asked. `/check` runs `flutter analyze`/`flutter test`/`build_runner` and spot-checks the §5 non-negotiables; treat a task as incomplete until it reports PASS. `/done` (`.claude/commands/done.md`) is the separate, user-invoked step that checks off the task in `docs/PHASES.md`, advances the "Active Task" line above, and commits (+ pushes if a remote is configured) — only run `/done` when the user asks for it.

## 7. Known open items — flag, don't resolve unilaterally

- Final brand name / visual identity (currently placeholder red palette, not final)
- Target country/region for compliance review — affects minimum donor age, data privacy handling
- Direct donor-to-donor requests: in or out of scope for Stage 4 — unconfirmed
- Whether home banner carousel items deep-link to a partner's bank profile or stay pure branding
- Google Maps API key not yet configured natively (iOS `AppDelegate`/`Info.plist`, Android `AndroidManifest.xml`). `google_maps_flutter` is a declared dependency and screens can be built/analyzed/tested against it, but any `GoogleMap` widget won't render real tiles on a device/simulator until this is set up. First hit in 1B-6 (manage partners map picker); will resurface in 1B-8/1B-9 (bank locator) and 4A-1/4A-2 (camps) — don't rediscover it each time, just note the screen is built and flag map rendering as blocked on this key.
- `lib/features/donor_profile/application/donor_profile_setup_controller.dart` (1B-4) still has the `FirebaseAuth.instance.currentUser!.uid` force-unwrap pattern that was fixed in `partner_form_controller.dart` (1B-6) — same fix applies (null-check → throw `StateError` → let the existing `AsyncValue.guard` carry it to the screen's error handling). Not blocking, but apply it next time that file is touched rather than rediscovering the issue.
- Android Gradle Plugin is pinned at 8.9.1 (`android/settings.gradle.kts`); Flutter's tooling warns support for it will soon be dropped and recommends moving to ≥8.11.1. Surfaced during the Phase 1B gate check's native build verification, not blocking any build today — bump it when it starts failing or the next time Android tooling is touched, rather than rediscovering the warning from scratch.
- Cloud Functions require the Firebase project to be on the Blaze (pay-as-you-go) plan — 2nd-gen functions (`firebase-functions` v7, used here) need Cloud Build/Artifact Registry/Eventarc APIs that only enable on Blaze, even for free-tier-level usage. `bloodlink-dev-wt` was upgraded to Blaze with a budget alert for 2A-2's `onRequestCreated` deploy. `bloodlink-prod` (not yet created — see the "two Firebase projects minimum" note in `docs/FIREBASE_SETUP.md`) will need the same upgrade + budget alert before any Cloud Function can deploy there. Flag this ahead of launch rather than discovering it mid-launch-prep.

If a task depends on one of these being resolved, say so explicitly rather than picking an answer and moving on.

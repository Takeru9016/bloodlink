# DESIGN_SYSTEM — tokens and component shapes

Source: a Dribbble-style reference UI kit ("SaveLife" blood-donation app), adopted 2026-08-12 as the real brand direction — supersedes the placeholder red palette below. Two things the reference shows that were deliberately **not** adopted, per explicit product decisions:
- **Per-donor "Request for Donate" / Accept-Reject flow.** The reference is peer-to-peer; this app is bank-mediated-matching-only (non-negotiable, see main `CLAUDE.md` §5/§7 — donor-to-donor requests are still unconfirmed by the client). Donor directory and request-blood screens are reskinned visually only; no request-to-a-specific-donor action was added.
- **3-tab bottom nav.** The reference uses 3 consumer tabs; this app has 5 speced consumer screens (Home, Request, Banks, Donors, Profile) plus an 8-section admin area. Collapsing tabs would drop Banks/Donors from primary navigation — an information-architecture change, not a visual one. Consumer nav stays at 5 tabs (restyled); admin's 8 sections moved from a cramped bottom bar to a drawer (see §Navigation).

## Colors
| Token | Hex (approx) | Usage |
|---|---|---|
| `brand.red` | `#E63950` | Primary actions, active states, brand accent (buttons, active nav icon, badges) |
| `brand.redDark` | `#A61E38` | Pressed states, splash screen / header backgrounds |
| `text.primary` | `#1B1B1F` | Headings, primary body text |
| `text.secondary` | `#8B8B93` | Secondary/meta text |
| `surface` | `#FFFFFF` | Base background, cards |
| `surface.muted` | `#F4F5FA` | Page background, filled input fill, placeholder blocks |
| `border` | `#E8E8EE` | Dividers — inputs are filled, not bordered, so this is rarely visible |
| `success` | `#2E9E5B` | Verified badges, positive states |
| `amber` | `#C98A1D` | Pending/warning badges |
| `error` | `#E2703A` | Form validation errors — deliberately orange-leaning, not another red, so it doesn't read as a CTA/active state now that `brand.red` itself is a vivid red |

Hex values are close estimates read off the reference image, not pixel-sampled — treat as "this direction," confirm exact values against a real Figma/brand file if pixel precision ever matters. Implemented as a `ThemeExtension` under `lib/core/theme/app_theme.dart` so this table is the single source of truth — one file to edit, not a find-and-replace across the codebase.

## Typography
Font: Inter (Regular, Medium, Semi Bold, Bold) — kept from the placeholder system. The reference's font looks like a rounded geometric sans (Poppins-adjacent); Inter was kept deliberately since it's already wired via `google_fonts` and visually close enough (clean, geometric, good weight range) — swapping the actual font family is a one-line change in `app_theme.dart` if a real brand font is ever specified.

| Style | Size | Weight |
|---|---|---|
| Page heading | 24 | Bold |
| Section heading | 18 | Semi Bold |
| Body | 15 | Regular |
| Secondary | 13 | Regular |
| Caption | 12 | Medium |

Define these as `TextTheme` entries, not inline `TextStyle` calls scattered through screens.

## Components
- **Button (filled)**: capsule shape (28px corner radius), `brand.red` fill, white 15/Semi Bold label, 54px height
- **Button (outline)**: capsule shape (28px corner radius), transparent fill, `border` stroke, `text.primary` label
- **Input**: 16px corner radius, filled — `surface.muted` fill, no visible border (focus state gets a subtle `brand.red` outline), 52px height, 12/Medium label above the field
- **Card**: 18px corner radius, `surface` fill (white, not `surface.muted` — the reference floats white cards on a light lavender page background), soft shadow (`black @ 6% alpha`, small blur/offset) — this is a deliberate change from the prior "flat, no shadows" rule
- **Badge**: pill shape (12px radius / fully round at badge height), colored text on a tinted background (success/amber variants for verified/pending), or solid `brand.red` + white text for the small blood-group pills on avatar cards
- **Illustrations**: the reference's onboarding leans on custom medical illustrations that don't exist as brand assets — reskinned screens use icon-based/geometric placeholders instead of fabricating illustration art. Revisit if the client commissions real illustrations.

Build these once as shared widgets under `lib/shared/widgets/` (`AppButton`, `AppInput`, `AppCard`, `AppBadge`) and reuse everywhere — do not hand-roll button/input styling per screen.

## Navigation
- **Consumer bottom nav**: 5 items (Home, Request, Banks, Donors, Profile), restyled to the reference's cleaner look (still a `NavigationBar`, no IA change) — active item in `brand.red`.
- **Admin nav**: was an 8-item `NavigationBar` (Partners, Stock, Carousel, Education, Moderation, Donors, Camps, Help) — cramped past the point styling alone fixes. Replaced with a drawer (`AdminDrawer`, mirroring the existing `AppDrawer` pattern already used on Home for secondary consumer items) opened from a top `AppBar`, listing all 8 sections.

## Layout
- Reference mobile frame: 360pt width
- Screen horizontal padding: 20px
- Standard vertical rhythm between sections: 14-16px

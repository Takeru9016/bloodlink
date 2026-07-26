# DESIGN_SYSTEM — tokens and component shapes

Source: the Figma hi-fi file (link should be in the project's shared docs — ask if you don't have it). This file is the code-facing quick reference; Figma is the visual source of truth.

## Colors
| Token | Hex (approx) | Usage |
|---|---|---|
| `brand.red` | `#A31B1B` | Primary actions, active states, brand accents |
| `brand.redDark` | `#712222` | Pressed states |
| `text.primary` | `#0F0F0E` | Headings, primary body text |
| `text.secondary` | `#665F5F` | Secondary/meta text |
| `surface` | `#FFFFFF` | Base background |
| `surface.muted` | `#F5F2EF` | Cards, placeholder blocks |
| `border` | `#D3CFCA` | Dividers, input borders |
| `success` | `#298C5A` | Verified badges, positive states |
| `amber` | `#B37A16` | Pending/warning badges |

Placeholder brand values pending the client's actual brand identity (`CLAUDE.md` Section 7). Implement these as a `ThemeExtension` under `lib/core/theme/` so swapping the palette later is a one-file change, not a find-and-replace across the codebase.

## Typography
Font: Inter (Regular, Medium, Semi Bold, Bold).

| Style | Size | Weight |
|---|---|---|
| Page heading | 24 | Bold |
| Section heading | 18 | Semi Bold |
| Body | 15 | Regular |
| Secondary | 13 | Regular |
| Caption | 12 | Medium |

Define these as `TextTheme` entries, not inline `TextStyle` calls scattered through screens.

## Components
- **Button (filled)**: 8px corner radius, `brand.red` fill, white 14/Semi Bold label, 44-46px height
- **Button (outline)**: 8px corner radius, transparent fill, `border` stroke, `text.primary` label
- **Input**: 8px corner radius, `surface` fill, `border` stroke, 44px height, 12/Medium label above the field
- **Card**: 10-14px corner radius, `surface.muted` fill, flat — no shadows/gradients
- **Badge**: pill shape (~6px radius), colored text on a tinted background (success/amber variants for verified/pending)
- **Bottom nav**: 5 items on consumer screens (Home, Request, Banks, Donors, Profile), active item in `brand.red`

Build these once as shared widgets under `lib/shared/widgets/` (`AppButton`, `AppInput`, `AppCard`, `AppBadge`) and reuse everywhere — do not hand-roll button/input styling per screen.

## Layout
- Reference mobile frame: 360pt width
- Screen horizontal padding: 20px
- Standard vertical rhythm between sections: 14-16px

Scaffold a new Flutter screen for this app.

Given a screen name (e.g. "Bank locator"):
1. Look it up in `docs/SPEC.md` — every field, action, and state for that screen is specified there. Do not invent fields or behavior not listed.
2. Pull tokens from `docs/DESIGN_SYSTEM.md` — use the shared widgets under `lib/shared/widgets/` (`AppButton`, `AppInput`, `AppCard`, `AppBadge`) rather than hand-rolled styling.
3. Create the screen under `lib/features/<feature_name>/presentation/<screen_name>_screen.dart`.
4. Create/extend a Riverpod controller under `lib/features/<feature_name>/application/` for its state. Use `riverpod_generator` (`@riverpod` annotations), not manual `StateNotifierProvider` boilerplate.
5. Any Firestore access goes through `lib/data/repositories/` — never call `FirebaseFirestore.instance` directly from a widget or controller.
6. If the screen is Admin-only, gate it in the router (`lib/core/router/`) based on the signed-in user's `roles`, not just by hiding a nav item.
7. Add a basic widget test under the mirrored path in `test/`.

If the screen isn't in `docs/SPEC.md` yet, stop and ask before proceeding.

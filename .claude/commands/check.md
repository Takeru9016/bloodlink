Verify the current task (or phase) is actually done — the "Definition of done" gate already implied by `docs/PHASES.md` and the Gate Check prompts in `prompts/phase-*.md`. Do not skip this because a task "looks" finished, and do not report PASS if any step below was skipped or fudged.

Run, in order, and show full output for each:

1. `flutter analyze` — must report **0 issues**. Per CLAUDE.md §3 this must be clean before any commit is considered done. There is no "unused import is fine" exception except during the original 1A-1 dependency-bootstrap task.
2. `flutter test` — must pass. Trivial/placeholder tests passing is fine this early, but nothing may fail.
3. If any file touched this task uses `@freezed`, `@JsonSerializable`, or `@riverpod`/`@Riverpod`: run `flutter pub run build_runner build --delete-conflicting-outputs` and confirm it completes with no generator errors.
4. Spot-check anything touched this task against CLAUDE.md §5 non-negotiables:
   - Every Admin write path sets both `updatedBy` (acting admin's uid) and `updatedAt`
   - No blood group or donation-history value is passed to `print()`, a logger, or a crash/analytics call
   - No new "partner login" or "direct donor-to-donor request" flow was added without that being explicitly confirmed in scope
   - No blood request is routed to an individual donor instead of a partner bank
5. If this task is the last unchecked box in its phase in `docs/PHASES.md`, also run that phase's Gate Check block from the matching `prompts/phase-*.md` file (e.g. `flutter pub run build_runner build` + full analyze/test pass across the whole phase, not just this task's files).

Report **PASS** or **FAIL** with specifics. On FAIL: stop, state what's wrong, and fix it — do not suggest `/done` until this comes back PASS.

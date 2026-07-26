Mark the current task complete, update the tracker, and commit. This is the bookkeeping step — only run it after `/check` has reported PASS for the changes in question.

1. If `/check` hasn't been run against the current changes yet, run it first. Refuse to proceed if it comes back FAIL.
2. Read CLAUDE.md's "Active Task" line to get the task code just finished (e.g. `1A-1`).
3. In `docs/PHASES.md`:
   - Check off that task's box
   - Recompute that phase's `[ x / y tasks ]` and percentage
   - Recompute the `**Total: x / 44 tasks**` line at the bottom
4. Update CLAUDE.md's "Active Task" line to the next unchecked task code in `docs/PHASES.md`, in file order. If none remain, set it to `All phases complete`.
5. If every task in the just-finished phase is now checked, say so explicitly and note that its Gate Check block (in the matching `prompts/phase-*.md`) should be run before starting the next phase — don't run it yourself as part of `/done`, just flag it.
6. Stage and commit:
   - Check `git status` / `git diff` first — stage the real project files changed by this task, not build artifacts (`.gitignore` should already keep those out of `git status`; if something unexpected shows up untracked, ask before staging it)
   - Commit message: `<task code>: <short description>` (e.g. `1A-1: add project dependencies`) — a body line only if there's something non-obvious worth recording
   - Use the standard commit trailer convention (Co-Authored-By line)
7. Push:
   - If an `origin` remote is configured, push (`git push`, or `git push -u origin <branch>` if there's no upstream yet)
   - If no remote exists, commit locally only and say so — do not create or guess a remote

If there are uncommitted changes unrelated to the task just finished, flag them and ask rather than bundling them into this commit.

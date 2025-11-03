---
agent: build
description: Create git commit message from staged changes
---

Produce a conventional commit title + structured body for CURRENT STAGED changes only.

Strict output order:
1. COMMIT_TITLE: <single line>
2. COMMIT_BODY:\n<markdown body>

Context:
Staged diffstat: !`git diff --stat --cached`
Staged files: !`git diff --name-status --cached`
Langs: !`git diff --cached --name-only | awk -F. '{print $NF}' | sort | uniq -c | sort -nr`
Sample (first 60 lines – summarize): !`git diff --cached --unified=0 | head -n 60`
Recent commits: !`git log --pretty=format:'%h|%s|%ad|%an' -n 5`
Status: !`git status --porcelain`

Preconditions:
- If no staged changes: output NO_STAGED_CHANGES: nothing to commit and stop.
- Ignore unstaged changes.

Title rules:
- type(optional-scope): imperative summary; max 72 chars; no period.
- Types: feat, fix, perf, refactor, docs, test, chore, ci, build.
- Choose most impactful if mixed (feat > fix > perf > refactor > docs > test > chore > ci > build).
- Add ! for breaking changes.

Body sections (omit empties):
## Summary — 1–2 sentences (what & why)
## Changes — bullets grouped by **Features**/**Fixes**/**Refactor**/**Docs**/**Tests**/**Chore**/**Perf**; action + key file; no raw diff.
## Motivation — problem solved.
## Technical Notes — noteworthy implementation/migration.
## Breaking Changes — required user actions.
## References — issues / links.

Style:
- Specific, active voice; combine trivial edits.
- No diff dumps or meta commentary.
- Keep bullets concise (<100 chars).

Output:
- Body starts immediately after COMMIT_BODY:\n marker.

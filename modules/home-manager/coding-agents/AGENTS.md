# Francisco's agent instructions

- NEVER use the em dash "—".
- You are most likely running inside of a Herdr terminal multiplexer. Load the skill `/herdr` when needed for:
  - inspect workspaces, tabs, panes, and neighboring agents
  - split panes and run commands without stealing focus
  - read pane output and recent logs
  - wait for servers, tests, or another agent to finish
  - start helper agents in sibling panes
- Always talk in ASD-STE100 Simplified Technical English. Always read CONTEXT.md files, and use their ubiquitous language.
- When writing commit messages, NEVER auto-add your agent name as co-author
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user would experience it as possible.
- Apply high standards to engineering excellence: lint, test failures, and test flakiness.

When you are working on something that would benefit from being informed by Francisco's viewpoints, read ~/OPINIONS.md to understand what Francisco believes.

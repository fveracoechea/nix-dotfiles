{
  lib,
  system,
  pkgs,
  inputs,
  customPkgs,
  ...
}: let
  mcpPackages = inputs.mcp-servers-nix.packages.${system};
in {
  stylix.targets.opencode.enable = false;

  home.packages = [pkgs.lsof];

  programs.opencode = {
    enable = true;
    package = customPkgs.opencode;
    settings = {
      theme = "system";
      autoupdate = false;

      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          options = {
            baseURL = "http://127.0.0.1:11434/v1";
          };
          models = {
            "qwen3:14b" = {
              tools = true;
              reasoning = true;
              description = "General purpose model with strong reasoning and multilingual capabilities";
            };
            "qwen3-coder:latest" = {
              tools = true;
              # reasoning = true;
              description = "Performant long context models for agentic and coding tasks";
            };
            "mistral-small3.2:latest" = {
              tools = true;
              reasoning = true;
              description = "Highly capable model for general tasks";
            };
            "devstral:latest" = {
              tools = true;
              reasoning = true;
              description = "An agentic LLM for software engineering tasks";
            };
          };
        };
      };

      mcp = {
        fetch = {
          enabled = true;
          type = "local";
          command = ["docker" "run" "-i" "--rm" "mcp/fetch"];
        };
        memory = {
          enabled = true;
          type = "local";
          command = ["${mcpPackages.mcp-server-memory}/bin/mcp-server-memory"];
        };
        playwright = {
          enabled = true;
          type = "local";
          command =
            [
              "${mcpPackages.playwright-mcp}/bin/mcp-server-playwright"
              "--executable-path"
            ]
            ++ lib.optionals pkgs.stdenv.isLinux [
              "${pkgs.chromium}/bin/chromium"
            ]
            ++ lib.optionals pkgs.stdenv.isDarwin [
              "${pkgs.google-chrome}/bin/google-chrome-stable"
            ];
        };
        sequential-thinking = {
          enabled = true;
          type = "local";
          command = ["${mcpPackages.mcp-server-sequential-thinking}/bin/mcp-server-sequential-thinking"];
        };
        time = {
          enabled = true;
          type = "local";
          command = ["${mcpPackages.mcp-server-time}/bin/mcp-server-time"];
        };
        grep = {
          enabled = true;
          type = "remote";
          url = "https://mcp.grep.app";
        };
      };
      command = {
        "create-pr" = {
          description = "Create or Update GitHub pull request for current branch";
          agent = "build";
          template = ''
            Create or Update a high‑quality GitHub Pull Request for the current branch.

            Strict output order:
            1. PR_TITLE: <title only, no quotes>
            2. PR_BODY:\n<markdown body>

            Context Data
            Branch: !`git rev-parse --abbrev-ref HEAD`
            Base branch candidates: main master
            Branch ahead/behind main: !`git rev-list --left-right --count origin/main...HEAD 2>/dev/null || echo "0\t0"`
            Commits (hash|subject|author|date): !`git log --pretty=format:'%h|%s|%an|%ad' --date=short main...HEAD`
            Diffstat: !`git diff --stat main...HEAD`
            Changed files: !`git diff --name-status main...HEAD`
            Languages touched: !`git diff --name-only main...HEAD | awk -F. '{print $NF}' | sort | uniq -c | sort -nr`
            Sample diff (first 50 lines, summarize only): !`git diff --unified=0 main...HEAD | head -n 50`

            Title rules (PR_TITLE):
            - Max 72 chars, imperative mood.
            - Prefer conventional commit style type(scope): summary if a dominant type (feat, fix, refactor, chore, docs, test) exists.
            - If multiple types, choose the most user-impacting (feat > fix > refactor > chore > docs > test).
            - Add ! before : if breaking change.

            PR_BODY sections (markdown):
            ## Summary
            1–3 sentence plain-language overview (what & why).
            ## Motivation
            Problem or goal; link issues if commit messages reference #ids.
            ## Changes
            Group bullets under bold sub-headings (Features, Fixes, Refactors, Docs, Tests, Chore). Each bullet: concise change + key file/module. Mark breaking changes with **BREAKING**.
            ## Technical Notes
            Important implementation details, trade-offs, migrations.

            Procedure:
            1. Verify clean working tree (!`git status --porcelain`). If not clean: stop & ask user to commit.
            2. Assume base = main unless otherwise required.
            3. Ensure branch is pushed (git push -u origin <branch>) if remote branch missing.
            4. If no commits vs main: abort politely (no PR needed).
            5. If a PR already exists (gh pr view --json url): return its URL only.
            6. Synthesize PR_TITLE & PR_BODY per rules; do NOT dump raw diff—summarize.
            7. Create PR: gh pr create --title "PR_TITLE" --body "PR_BODY"
            8. Output: PR_URL: <url>

            Style / quality:
            - Summaries should be specific, avoid generic words like "update" alone.
            - Merge related tiny commits into single bullets.
            - Highlight user-visible impacts first.
            - Omit boilerplate. Keep body scannable.

            Be concise with shell usage; only run required commands.
          '';
        };
      };
    };
  };
}

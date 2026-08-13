{
  codingAgentSources,
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.dotfiles.coding-agents.enable {
    home.packages = with pkgs; [
      lsof
      mcp-nixos
    ];

    home.sessionVariables = {
      OPENCODE_ENABLE_EXA = "true";
      OPENCODE_EXPERIMENTAL_LSP_TOOL = "true";
    };

    programs.opencode = {
      enable = true;

      context = ./AGENTS.md;

      commands = {
        create-pr = ./command/create-pr.md;
      };

      tui = {
        theme = "system";
      };

      # `opencode.json` has no `skills` key; OpenCode auto-discovers skills from
      # `~/.config/opencode/skills/<name>/SKILL.md`, which this option writes.
      skills = {
        herdr = "${codingAgentSources.herdr}/skills/herdr";
        hunk-review = "${codingAgentSources.hunk}/skills/hunk-review";
        # Pulled into `.agents/skills` by `bunx skills`; see `skills-lock.json`.
        babysit-pr = ../../../.agents/skills/babysit-pr;
      };

      settings = {
        autoupdate = false;

        # permission.external_directory."~/OPINIONS.md" = "allow";
        permission."*" = "allow";

        mcp = {
          grep = {
            enabled = true;
            type = "remote";
            url = "https://mcp.grep.app";
          };
        };

        lsp = {
          nixd = {
            command = ["nixd"];
            extensions = [".nix"];
          };
          lua_ls = {
            command = ["lua-language-server"];
            extensions = [".lua"];
          };
          biome = {
            command = ["biome" "lsp-proxy"];
            extensions = [
              ".js"
              ".jsx"
              ".ts"
              ".tsx"
              ".json"
              ".jsonc"
              ".css"
              ".html"
              ".graphql"
              ".vue"
              ".svelte"
              ".astro"
            ];
          };
          stylelint = {
            command = ["stylelint-language-server" "--stdio"];
            extensions = [
              ".css"
              ".scss"
              ".less"
              ".html"
              ".vue"
              ".astro"
            ];
          };
          oxlint = {
            command = ["oxlint" "--lsp"];
            extensions = [
              ".js"
              ".jsx"
              ".ts"
              ".tsx"
              ".vue"
              ".svelte"
              ".astro"
            ];
          };
          oxfmt = {
            command = ["oxfmt" "--lsp"];
            extensions = [
              ".js"
              ".jsx"
              ".ts"
              ".tsx"
              ".toml"
              ".json"
              ".jsonc"
              ".json5"
              ".yaml"
              ".yml"
              ".html"
              ".vue"
              ".handlebars"
              ".hbs"
              ".css"
              ".scss"
              ".less"
              ".graphql"
              ".md"
            ];
          };
        };
      };
    };
  };
}

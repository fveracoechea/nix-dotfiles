{
  lib,
  config,
  inputs,
  ...
}: {
  config = lib.mkIf config.dotfiles.coding-agents.enable {
    programs.claude-code = {
      enable = true;

      context = ./AGENTS.md;

      settings = {
        theme = "dark-ansi";

        model = "claude-opus-5";
        effortLevel = "medium";

        statusLine = {
          type = "command";
          command = "${./claude-statusline.sh}";
        };

        permissions = {
          deny = [
            "EnterPlanMode"
            "ExitPlanMode"
            "DesignSync"
            "NotebookEdit"
            "PushNotification"
            "RemoteTrigger"
            "ReportFindings"
            "ScheduleWakeup"
            "AskUserQuestion"
            "CronCreate"
            "CronDelete"
            "CronList"
          ];
        };

        disableBundledSkills = true;
        disableWorkflows = true;
        disableRemoteControl = true;
        disableClaudeAiConnectors = true;
        disableArtifact = true;
      };

      skills = {
        herdr = "${inputs.herdr}/skills/herdr/SKILL.md";
        hunk-review = "${inputs.hunk}/skills/hunk-review/SKILL.md";
        playwriter = "${inputs.playwriter}/skills/playwriter/SKILL.md";
      };

      plugins = {
        figma = inputs.figma-plugin;
      };

      lspServers = {
        nixd = {
          command = "nixd";
          extensionToLanguage = {".nix" = "nix";};
        };
        lua_ls = {
          command = "lua-language-server";
          extensionToLanguage = {".lua" = "lua";};
        };
        stylelint = {
          command = "stylelint-language-server";
          args = ["--stdio"];
          extensionToLanguage = {
            ".css" = "css";
            ".scss" = "scss";
            ".less" = "less";
            ".html" = "html";
            ".vue" = "vue";
            ".astro" = "astro";
          };
        };
        oxlint = {
          command = "oxlint";
          args = ["--lsp"];
          extensionToLanguage = {
            ".js" = "javascript";
            ".jsx" = "javascriptreact";
            ".ts" = "typescript";
            ".tsx" = "typescriptreact";
            ".vue" = "vue";
            ".svelte" = "svelte";
            ".astro" = "astro";
          };
        };
        oxfmt = {
          command = "oxfmt";
          args = ["--lsp"];
          extensionToLanguage = {
            ".js" = "javascript";
            ".jsx" = "javascriptreact";
            ".ts" = "typescript";
            ".tsx" = "typescriptreact";
            ".toml" = "toml";
            ".json" = "json";
            ".jsonc" = "jsonc";
            ".json5" = "json5";
            ".yaml" = "yaml";
            ".yml" = "yaml";
            ".html" = "html";
            ".vue" = "vue";
            ".handlebars" = "handlebars";
            ".hbs" = "handlebars";
            ".css" = "css";
            ".scss" = "scss";
            ".less" = "less";
            ".graphql" = "graphql";
            ".md" = "markdown";
          };
        };
      };
    };
  };
}

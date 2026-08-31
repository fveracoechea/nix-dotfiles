{
  lib,
  config,
  pkgs,
  dotfilesPkgs,
  codingAgentSources,
  ...
}: let
  # Declarative equivalent of `herdr integration install claude|opencode`,
  # which cannot patch the read-only configs home-manager writes.
  assets = "${codingAgentSources.herdr}/src/integration/assets";

  claudeHook = "${config.programs.claude-code.configDir}/hooks/herdr-agent-state.sh";
in {
  config = lib.mkIf config.dotfiles.coding-agents.enable {
    programs.herdr = {
      enable = true;
      package = dotfilesPkgs.herdr;
      settings = {
        onboarding = false;

        keys = {
          prefix = "ctrl+b";
          detach = "prefix+d";
          goto = "prefix+s";
          settings = "prefix+g";
          navigate_workspace_down = "j";
          navigate_workspace_up = "k";
        };

        theme = {
          auto_switch = false;
          name = "catppuccin";
        };

        ui = {
          sidebar_width = 32;
          agent_panel_sort = "spaces";
          show_agent_labels_on_pane_borders = true;
        };
      };
    };

    programs.claude-code = {
      hooks."herdr-agent-state.sh" = "${assets}/claude/herdr-agent-state.sh";

      settings.hooks.SessionStart = [
        {
          matcher = "*";
          hooks = [
            {
              type = "command";
              command = "bash '${claudeHook}' session";
              timeout = 10;
            }
          ];
        }
      ];
    };

    # opencode merges tui.json and tui.jsonc, so this coexists with
    # `programs.opencode.tui`.
    xdg.configFile = {
      "opencode/plugins/herdr-agent-state.js".source = "${assets}/opencode/herdr-agent-state.js";
      "opencode/herdr-tui-session.js".source = "${assets}/opencode/herdr-tui-session.js";
      "opencode/tui.jsonc".source = (pkgs.formats.json {}).generate "herdr-tui.jsonc" {
        plugin = ["./herdr-tui-session.js"];
      };
    };
  };
}

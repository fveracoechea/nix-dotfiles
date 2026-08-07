{
  lib,
  config,
  dotfilesPkgs,
  ...
}: {
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
        };

        theme = {
          auto_switch = false;
          dark_name = "catppuccin";
          light_name = "catppuccin-latte";
          name = "catppuccin";
        };

        ui = {
          agent_panel_sort = "spaces";
        };
      };
    };
  };
}

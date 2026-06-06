{pkgs, ...}: {
  home.packages = [pkgs.lsof];

  programs.opencode = {
    enable = true;

    commands = {
      create-pr = ./command/create-pr.md;
    };

    tui = {
      theme = "system";
    };

    settings = {
      autoupdate = false;
      mcp = {
        grep = {
          enabled = true;
          type = "remote";
          url = "https://mcp.grep.app";
        };
      };
    };
  };
}

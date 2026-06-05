{pkgs, ...}: {
  home.packages = [pkgs.lsof];

  programs.opencode = {
    enable = true;

    commands = {
      create-commit = ./command/create-commit.md;
      create-pr = ./command/create-pr.md;
    };

    settings = {
      autoupdate = false;
      tui = {
        theme = "system";
      };
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

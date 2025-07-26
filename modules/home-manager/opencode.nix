{pkgs, ...}: {
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;
    settings = {
      theme = "catppuccin";
      autoupdate = false;
    };
  };
}

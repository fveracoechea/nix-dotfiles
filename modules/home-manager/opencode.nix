{pkgs, ...}: {
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;
    settings = {
      theme = "system";
      autoupdate = false;
    };
  };
}

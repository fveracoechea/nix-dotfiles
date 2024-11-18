{pkgs, ...}: {
  # sets ZSH has default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.pathsToLink = ["/share/zsh"];
  environment.shells = with pkgs; [zsh];
}

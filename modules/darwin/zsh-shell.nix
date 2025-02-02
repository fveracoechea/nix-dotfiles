{pkgs, ...}: {
  # Enable ZSH has default shell
  programs.zsh.enable = true;
  environment.pathsToLink = ["/share/zsh"];
  environment.shells = [pkgs.zsh];
  programs.bash.enable = false;
}

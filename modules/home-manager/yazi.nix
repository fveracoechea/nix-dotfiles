{pkgs, ...}: {
  stylix.targets.yazi.enable = false;

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    plugins = with pkgs.yaziPlugins; [
      yatline
      yatline-cattpuccin
    ];
  };
}

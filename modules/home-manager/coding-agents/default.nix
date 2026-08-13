{
  lib,
  config,
  pkgs,
  dotfilesPkgs,
  ...
}: {
  options.dotfiles.coding-agents.enable = lib.mkEnableOption "OpenCode and Claude";

  config = lib.mkIf config.dotfiles.coding-agents.enable {
    home.file."OPINIONS.md".source = ./OPINIONS.md;

    home.packages = with pkgs; [
      # Runs the babysit-pr watcher script (standard library only).
      python3
      nixd
      lua-language-server
      biome
      # oxlint
      oxfmt
      dotfilesPkgs.stylelint-language-server
    ];
  };

  imports = [./opencode.nix ./claude-code.nix ./herdr.nix];
}

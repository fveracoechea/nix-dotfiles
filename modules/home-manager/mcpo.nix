{
  pkgs,
  customPkgs,
  inputs,
  config,
  ...
}: {
  home.packages = [
    customPkgs.mcpo
  ];

  xdg.configFile."mcpo/config.json".source = inputs.mcp-servers-nix.lib.mkConfig pkgs {
    programs = {
      time.enable = true;
      playwright.enable = true;
      sequential-thinking.enable = true;
      git.enable = true;
      memory.enable = true;
      context7.enable = true;
    };
    settings.servers = {
      fetch = {
        command = "docker";
        args = ["run" "-i" "--rm" "mcp/fetch"];
      };
      filesystem = {
        command = "npx";
        args = [
          "-y"
          "@modelcontextprotocol/server-filesystem"
          "${config.home.homeDirectory}/Code"
          "${config.home.homeDirectory}/dotfiles"
        ];
      };
    };
  };
}

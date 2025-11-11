{
  pkgs,
  customPkgs,
  inputs,
  ...
}: {
  home.packages = [
    customPkgs.mcpo
  ];

  xdg.configFile."mcpo/config.json".source = inputs.mcp-servers-nix.lib.mkConfig pkgs {
    programs = {
      time.enable = true;
      playwright.enable = true;
      memory.enable = true;
      context7.enable = true;
    };
    settings.servers = {
      grep = {
        type = "streamable-http";
        url = "https://mcp.grep.app";
      };
      fetch = {
        command = "docker";
        args = ["run" "-i" "--rm" "mcp/fetch"];
      };
    };
  };
}

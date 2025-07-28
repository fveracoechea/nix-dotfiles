{customPkgs, ...}: {
  home.packages = [
    customPkgs.mcpo
  ];

  xdg.configFile."mcpo/config.json".text = builtins.toJSON {
    mcpServers = {
      context7 = {
        command = "npx";
        args = ["-y" "@upstash/context7-mcp"];
      };
      sequential-thinking = {
        command = "npx";
        args = ["-y" "@modelcontextprotocol/server-sequential-thinking"];
      };
      playwright = {
        command = "nix";
        args = ["run" "github:akirak/nix-playwright-mcp"];
      };
      fetch = {
        command = "docker";
        args = ["run" "-i" "--rm" "mcp/fetch"];
      };
    };
  };
}

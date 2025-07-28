{customPkgs}: {
  home.packages = [
    customPkgs.mcpo
  ];

  xdg.configs."mcpo/config.json".text = builtins.toJSON {
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
        command = "npx";
        args = ["-y" "@playwright/mcp@latest"];
      };
    };
  };
}

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com" = {
        addKeysToAgent = "yes";
        identityFile = "~/.ssh/id_github_hypr";
        extraOptions = {
          UseKeychain = "yes";
        };
      };
    };
  };
}

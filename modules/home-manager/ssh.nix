{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "github.com" = {
        AddKeysToAgent = "yes";
        IdentityFile = "~/.ssh/id_github_hypr";
        UseKeychain = "yes";
      };
    };
  };
}

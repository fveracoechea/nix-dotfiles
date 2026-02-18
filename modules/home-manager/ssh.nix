{
  programs.ssh.matchBlocks = {
    "github.com" = {
      useKeychain = true;
      addKeysToAgent = true;
      identityFile = "~/.ssh/id_github_hypr";
    };
  };
}

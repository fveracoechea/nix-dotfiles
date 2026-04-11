{
  programs.git = {
    enable = true;
    signing.format = "openpgp";
    settings = {
      user = {
        email = "veracoecheafrancisco@gmail.com";
        name = "Francisco Veracoechea";
      };
      core = {
        editor = "nvim";
        sshCommand = "ssh -i ~/.ssh/id_github_hypr";
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autosquash = true;
      };
    };
  };
}

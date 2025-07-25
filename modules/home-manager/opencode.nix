{pkgs, ...}: {
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;
    settings = {
      theme = "catppuccin";
      autoupdate = false;
      agent = {
        code-reviewer = {
          description = "Reviews code for best practices and potential issues";
          prompt = "You are a code reviewer. Focus on security, performance, and maintainability.";
          tools = {
            write = false;
            edit = false;
          };
        };
      };
    };
  };
}

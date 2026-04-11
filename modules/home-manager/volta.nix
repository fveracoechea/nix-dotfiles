{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.volta
  ];

  home.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
    VOLTA_HOME = "${config.home.homeDirectory}/.volta";
  };

  home.sessionPath = [
    "$VOLTA_HOME/bin"
  ];
}

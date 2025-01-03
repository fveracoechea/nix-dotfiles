# Custom packages, that can be defined similarly to ones from nixpkgs
pkgs: {
  # example = pkgs.callPackage ./example { };

  fuzzel-notifications = pkgs.helpers.mkDenoDerivation {
    name = "fuzzel-notifications";
    src = ../scripts;
    entryPoint = "fuzzel-notifications.ts";
  };
}

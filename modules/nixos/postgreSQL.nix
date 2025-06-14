{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    beekeeper-studio
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "beekeeper-studio-5.2.12"
  ];

  services.postgresql = {
    enable = false;
    enableTCPIP = true;
    settings.port = 5433;
    authentication = lib.mkOverride 10 ''
      local all all              trust
      host  all all 127.0.0.1/32 trust
      host  all all ::1/128      trust
    '';
  };
}

{pkgs, ...}: {
  environment.systemPackages = [pkgs.ethtool];

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  networking.interfaces."eno1".wakeOnLan.enable = true;
}

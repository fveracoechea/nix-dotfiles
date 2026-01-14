{
  networking = {
    hostName = "nixos";
    interfaces."eno1".wakeOnLan.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [8888 11434];
    };

    wireless.enable = true;
    # networkmanager.wifi.backend = "iwd";
  };
}

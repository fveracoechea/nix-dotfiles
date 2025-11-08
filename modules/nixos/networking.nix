{
  networking = {
    hostName = "nixos";
    interfaces."eno1".wakeOnLan.enable = true;
    networkmanager.enable = true;
    wireless.iwd.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [8888 11434];
    };
  };
}

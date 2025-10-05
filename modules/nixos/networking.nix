{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    wireless.iwd.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [8888 11434];
    };
  };
}

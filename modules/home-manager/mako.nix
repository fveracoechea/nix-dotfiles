{...}: {
  services.mako = {
    enable = true;
    anchor = "bottom-center";
    margin = "24,12";
    padding = "24";
    defaultTimeout = 5000;
    borderRadius = 8;
    borderSize = 3;
    extraConfig = ''
      max-history=15

      # Colors https://github.com/catppuccin/mako
      background-color=#1e1e2e
      text-color=#cdd6f4
      border-color=#fab387
      progress-color=over #313244

      [urgency=high]
      border-color=#fab387

      [mode=away]
      default-timeout=0
      ignore-timeout=1
    '';
  };
}

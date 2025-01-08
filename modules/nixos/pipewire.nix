{inputs, ...}: {
  imports = [
    inputs.musnix.nixosModules.musnix
  ];

  # Enable audio with PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # PipeWire requires this to be false
  services.pulseaudio.enable = false;

  # Enable musnix, a module for real-time audio.
  musnix.enable = true;
}

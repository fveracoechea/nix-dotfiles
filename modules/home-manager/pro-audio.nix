{pkgs, ...}: {
  home.packages = with pkgs; [
    # Apps
    # zrythm
    reaper
    bitwig-studio
    # ardour

    # Music editor
    # tuxguitar

    # Audio plugins (LV2, VST2, VST3, LADSPA)
    # distrho-ports
    calf
    eq10q
    lsp-plugins
    tap-plugins
    x42-plugins
    x42-gmsynth
    gxplugins-lv2
    dragonfly-reverb
    guitarix
    fil-plugins
    geonkick

    # Support for Windows VST2/VST3 plugins
    yabridge
    yabridgectl
    wineWowPackages.stable
  ];
}

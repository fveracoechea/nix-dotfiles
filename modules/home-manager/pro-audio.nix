{pkgs, ...}: {
  home.packages = with pkgs; [
    # Apps
    # zrythm
    ardour
    # audacity
    reaper

    # Music editor
    tuxguitar

    # Audio plugins (LV2, VST2, VST3, LADSPA)
    guitarix

    # packs
    gxplugins-lv2
    lsp-plugins
    tap-plugins
    infamousPlugins
    # general
    helm
    cardinal
    dragonfly-reverb
    # Drums
    geonkick
    # distortion
    fire
    wolf-shaper

    # Support for Windows VST2/VST3 plugins
    yabridge
    yabridgectl
    # wineWowPackages.stable
  ];
}

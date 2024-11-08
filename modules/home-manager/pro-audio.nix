{
  config,
  pkgs,
  lib,
  ...
}: let
  home = config.home.homeDirectory;

  plugins = with pkgs; [
    # packs
    gxplugins-lv2
    lsp-plugins
    tap-plugins
    infamousPlugins
    # general
    helm
    cardinal
    # Drums
    geonkick
    # distortion
    fire
    wolf-shaper
  ];

  # lv2_path will look like:
  # ${helm}/lib/lv2:$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2
  # this is just more general to loop over all plugins as makeSearchPath adds lib/lv2 to all
  # outputs and concat them with a colon in between as explained in:
  lv2_path = lib.makeSearchPath "lib/lv2" plugins;
  clap_path = lib.makeSearchPath "lib/clap" plugins;
  vst3_path = lib.makeSearchPath "lib/vst3" plugins;
  vst_path = lib.makeSearchPath "lib/vst" plugins;
  lxvst_path = lib.makeSearchPath "lib/lxvst" plugins;
  ladspa_path = lib.makeSearchPath "lib/ladspa" plugins;
  dssi_path = lib.makeSearchPath "lib/dssi" plugins;

  wrapProgram = {
    programToWrap,
    filesToWrap ? "*",
  }:
    pkgs.runCommand
    # name of the program, like ardour-with-plugins-8
    (programToWrap.pname + "-with-plugins-" + programToWrap.version)
    {
      nativeBuildInputs = with pkgs; [
        makeBinaryWrapper
      ];
      buildInputs = [
        programToWrap
      ];
    }
    ''
      mkdir -p $out/bin
      for file in ${programToWrap}/bin/${filesToWrap};
      do
        filename="$(basename -- $file)"
        makeWrapper "$file" "$out/bin/$filename"  \
          --prefix LV2_PATH    : "${lv2_path}"    \
          --prefix CLAP_PATH   : "${clap_path}"   \
          --prefix VST3_PATH   : "${vst3_path}"   \
          --prefix VST_PATH    : "${vst_path}"    \
          --prefix LXVST_PATH  : "${lxvst_path}"  \
          --prefix LADSPA_PATH : "${ladspa_path}" \
          --prefix DSSI_PATH   : "${dssi_path}"   ;
      done
    '';
in {
  home.packages = with pkgs; [
    # Apps
    (wrapProgram {programToWrap = pkgs.ardour;})
    (wrapProgram {programToWrap = pkgs.audacity;})
    (wrapProgram {programToWrap = pkgs.zrythm;})
    (wrapProgram {programToWrap = pkgs.carla;})

    tuxguitar
  ];
}

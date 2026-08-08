{lib, config, ...}: {
  options.dotfiles.sunshine.enable = lib.mkEnableOption "Sunshine game streaming config";

  config = lib.mkIf config.dotfiles.sunshine.enable {
    # NOTE: managed declaratively, so the web UI can't persist changes to this file
    xdg.configFile."sunshine/sunshine.conf".text = ''
      vaapi_strict_rc_buffer = enabled
      capture = kms
      output_name = HDMI-A-1
    '';

    xdg.configFile."sunshine/apps.json".text = builtins.toJSON {
      env = {
        "PATH" = "$(PATH):$(HOME)/.local/bin";
      };
      apps = [
        {
          name = "Desktop";
          image-path = "desktop.png";
          prep-cmd = [
            {
              do = "enable-stream-output";
              undo = "disable-stream-output";
            }
          ];
        }
        {
          name = "Steam Big Picture";
          image-path = "steam.png";
          auto-detach = "true";
          prep-cmd = [
            {
              do = "enable-stream-output";
              undo = "disable-stream-output";
            }
          ];
        }
      ];
    };
  };
}

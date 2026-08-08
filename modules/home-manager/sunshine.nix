{
  pkgs,
  lib,
  config,
  ...
}: {
  options.dotfiles.sunshine.enable = lib.mkEnableOption "Sunshine game streaming config";

  config = lib.mkIf config.dotfiles.sunshine.enable {
    # NOTE: managed declaratively, so the web UI can't persist changes to this file
    xdg.configFile."sunshine/sunshine.conf".text = ''
      vaapi_strict_rc_buffer = enabled
      encoder = vaapi
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

    # Toggle the Dummy Plug output inside Hyprland (no-op elsewhere)
    home.packages = [
      (pkgs.writers.writeBashBin "enable-stream-output" ''
        hyprctl keyword monitor "HDMI-A-1, 3840x2160@120, 5120x0, 1" || true
      '')
      (pkgs.writers.writeBashBin "disable-stream-output" ''
        hyprctl keyword monitor "HDMI-A-1, disable" || true
      '')
    ];
  };
}

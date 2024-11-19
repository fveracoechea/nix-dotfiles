{lib, ...}: let
  description = ''
    Change caps_lock to left_control if pressed with other keys,
    change caps_lock to escape if pressed alone.
  '';
  key_code = key: {key_code = key;};
in {
  # enable xdg config directory by default
  xdg.enable = lib.mkDefault true;

  xdg.configFile.karabiner = {
    target = "karabiner/assets/complex_modifications/nix.json";
    text = builtins.toJSON {
      title = "CapsLock modifier - Nix managed";
      rules = [
        {
          inherit description;
          manipulators = [
            {
              type = "basic";
              from =
                (key_code "caps_lock")
                // {
                  modifiers = {optional = ["any"];};
                };
              to = [(key_code "left_control")];
              to_if_alone = [(key_code "escape")];
              conditions = [
                {
                  type = "device_if";
                  identifiers = [{is_built_in_keyboard = true;}];
                }
              ];
            }
          ];
        }
      ];
    };
  };
}

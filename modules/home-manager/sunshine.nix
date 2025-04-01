{...}: {
  xdg.configFile."sunshine/apps.json".text = builtins.toJSON {
    env = {
      "PATH" = "$(PATH):$(HOME)/.local/bin";
    };
    apps = [
      {
        name = "Steam 4K";
        image-path = "steam.png";
      }
    ];
  };
}

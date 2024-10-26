{lib, ...}:
with lib.hm.gvariant; {
  # Generated with dconf2nix
  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = ["variable-refresh-rate"];
    };

    "org/gnome/nautilus/preferences" = {
      search-filter-time-type = "last_modified";
      default-folder-viewer = "list-view";
      default-sort-order = "mtime";
    };

    "org/gnome/shell" = {
      always-show-log-out = true;
      disable-user-extensions = false;
      enabled-extensions = [
        "blur-my-shell@aunetx"
        "tilingshell@ferrarodomenico.com"
        "freon@UshakovVasilii_Github.yahoo.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "system-monitor@gnome-shell-extensions.gcampax.github.com"
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "google-chrome.desktop"
        "org.gnome.Settings.desktop"
        "kitty.desktop"
        "slack.desktop"
        "io.github.seadve.Kooha.desktop"
      ];
      disabled-extensions = [
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "light-style@gnome-shell-extensions.gcampax.github.com"
      ];
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      settings-version = 2;
    };

    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      blur = true;
    };

    "org/gnome/shell/extensions/blur-my-shell/hidetopbar" = {
      compatibility = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      blur = true;
      pipeline = "prpeline_default";
      style-components = 2;
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = true;
      force-light-text = true;
      pipeline = "pipeline_default";
      override-background = true;
      override-background-dynamically = false;
      static-blur = true;
      style-panel = 0;
      unblur-in-overview = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/freon" = {
      exec-method-freeipmi = "pkexec";
      hot-sensors = ["__average__" "__max__"];
      panel-box-index = 0;
      show-voltage = true;
      unit = "centigrade";
      update-time = 8;
      use-gpu-aticonfig = false;
      use-gpu-bumblebeenvidia = true;
      use-gpu-nvidia = false;
    };

    "org/gnome/shell/extensions/system-monitor" = {
      show-cpu = true;
      show-download = false;
      show-memory = true;
      show-swap = true;
      show-upload = false;
    };

    "world-clocks" = {
      locations = [];
    };

    "org/gnome/shell/extensions/tilingshell" = {
      enable-blur-selected-tilepreview = true;
      enable-blur-snap-assistant = true;
      inner-gaps = 16;
      last-version-name-installed = "11.1";
      outer-gaps = mkUint32 16;
      show-indicator = true;
    };
  };
}

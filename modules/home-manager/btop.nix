{ config, lib, pkgs, customUtils, ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      # Theme settings derived from Catppuccin Mocha palette
      color_theme = "Catppuccin-Mocha"; # custom theme name
      theme_background = true;
      truecolor = true;
      vim_keys = true;
      rounded_corners = true;
      graph_symbol = "braille";
      proc_gradient = true;
      temp_scale = "celsius";
      shown_boxes = "cpu mem net proc";
      update_ms = 1200;
    };
  };

  xdg.configFile."btop/themes/Catppuccin-Mocha.theme".text = let c = customUtils.catppuccin; in ''
# Catppuccin Mocha theme for btop
# Generated from palette in utils/catppuccin.nix
# https://github.com/catppuccin

# Color definitions
color00=${config.lib.stylix ? base16 ? base00 or c.base}

# btop theme format
# name: Catppuccin Mocha
# author: opencode

# Basic colors
theme[main_bg]="${c.base}"
theme[main_fg]="${c.text}"

# Title / highlights
theme[title]="${c.lavender}"
theme[hi_fg]="${c.blue}"

# Graphs
theme[graph_text]="${c.subtext1}"
theme[cpu_box]="${c.mauve}"
theme[mem_box]="${c.green}"
theme[net_box]="${c.sky}"
theme[proc_box]="${c.peach}"

# Meters gradients (start:end)
theme[cpu_start]="${c.teal}"
theme[cpu_mid]="${c.blue}"
theme[cpu_end]="${c.mauve}"

theme[mem_start]="${c.green}"
theme[mem_mid]="${c.yellow}"
theme[mem_end]="${c.peach}"

theme[net_recv]="${c.sky}"
theme[net_send]="${c.sapphire}"

# Processes list
theme[proc_fg]="${c.text}"
theme[proc_bg]="${c.surface0}"
theme[proc_selected]="${c.surface1}"
theme[proc_running]="${c.green}"

# Various
theme[divider]="${c.surface2}"
theme[selected_bg]="${c.surface0}"
theme[selected_fg]="${c.rosewater}"
theme[inactive_fg]="${c.overlay1}"
theme[warning]="${c.peach}"
theme[critical]="${c.red}"
't);
}

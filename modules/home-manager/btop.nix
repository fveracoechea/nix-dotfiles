{...}: {
  # stylix.targets.btop.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      truecolor = true;
      vim_keys = true;
      rounded_corners = true;
      graph_symbol = "braille";
      proc_gradient = true;
      temp_scale = "celsius";
    };
  };
}

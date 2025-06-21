{pkgs, ...}: let
  catppuccin = import ../../utils/catppuccin.nix;
in {
  # oh-my-posh theme and setup
  home.packages = [pkgs.oh-my-posh];

  xdg.configFile."zsh/oh-my-posh/catppuccin.json".text = builtins.toJSON {
    version = 3;
    final_space = true;
    enable_cursor_positioning = true;

    secondary_prompt = {
      foreground = catppuccin.text;
      background = "transparent";
      template = "❯❯ ";
    };

    blocks = let
      divider = {
        type = "text";
        style = "plain";
        foreground = catppuccin.text;
        background = "transparent";
        template = "  ";
      };
    in [
      {
        type = "prompt";
        alignment = "left";
        newline = true;
        segments = [
          {
            type = "os";
            style = "plain";
            foreground = catppuccin.text;
            background = "transparent";
            template = "\n{{ .Icon }} ";
          }
          {
            type = "session";
            style = "plain";
            foreground = catppuccin.blue;
            background = "transparent";
            template = " {{ .UserName }}{{ if .SSHSession }}    {{ .HostName }}{{ end }}";
          }
          divider
          {
            type = "path";
            style = "plain";
            foreground = catppuccin.pink;
            background = "transparent";
            template = "{{ .Path }}";
            properties = {
              home_icon = "~";
              style = "agnoster_full";
            };
          }
          divider
          {
            type = "executiontime";
            style = "plain";
            foreground = catppuccin.lavender;
            background = "transparent";
            template = " {{ .FormattedMs }}";
            properties = {
              style = "austin";
              always_enabled = true;
            };
          }
        ];
      }
      {
        type = "prompt";
        alignment = "left";
        newline = true;
        segments = [
          {
            type = "text";
            style = "plain";
            template = "❯ ";
            background = "transparent";
            foreground_templates = [
              "{{if gt .Code 0}}${catppuccin.red}{{end}}"
              "{{if eq .Code 0}}${catppuccin.text}{{end}}"
            ];
          }
        ];
      }
    ];
  };
}

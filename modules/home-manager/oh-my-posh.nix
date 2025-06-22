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

    blocks = [
      {
        type = "prompt";
        alignment = "left";
        newline = true;
        segments = [
          {
            type = "text";
            style = "plain";
            background = "transparent";
            template = "\n";
          }
          {
            type = "os";
            style = "diamond";
            powerline_symbol = "";
            leading_diamond = "";
            foreground = catppuccin.text;
            background = catppuccin.mantle;
            template = "{{ .Icon }} ";
            foreground_templates = [
              "{{if gt .Code 0}}${catppuccin.red}{{end}}"
              "{{if eq .Code 0}}${catppuccin.text}{{end}}"
            ];
          }
          {
            type = "session";
            style = "powerline";
            powerline_symbol = "";
            foreground = catppuccin.blue;
            background = catppuccin.mantle;
            template = "{{ .UserName }}{{ if .SSHSession }}    {{ .HostName }}{{ end }}";
          }
          {
            type = "path";
            style = "powerline";
            powerline_symbol = "";
            foreground = catppuccin.pink;
            background = catppuccin.mantle;
            template = " {{ .Path }} ";
            properties = {
              home_icon = "~";
              style = "agnoster_full";
            };
          }
          {
            type = "executiontime";
            style = "powerline";
            powerline_symbol = "";
            foreground = catppuccin.lavender;
            background = catppuccin.mantle;
            template = " {{ .FormattedMs }} ";
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
            template = "❯";
            background = "transparent";
            foreground = catppuccin.text;
          }
        ];
      }
    ];
  };
}

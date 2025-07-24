{pkgs, utils, ...}: {
  # oh-my-posh theme and setup
  home.packages = [pkgs.oh-my-posh];

  xdg.configFile."zsh/oh-my-posh/catppuccin.json".text = builtins.toJSON {
    version = 3;
    final_space = true;
    enable_cursor_positioning = true;

    secondary_prompt = {
      foreground = utils.catppuccin.text;
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
            foreground = utils.catppuccin.text;
            background = utils.catppuccin.mantle;
            template = "{{ .Icon }} ";
            foreground_templates = [
              "{{if gt .Code 0}}${utils.catppuccin.red}{{end}}"
              "{{if eq .Code 0}}${utils.catppuccin.text}{{end}}"
            ];
          }
          {
            type = "session";
            style = "powerline";
            powerline_symbol = "";
            foreground = utils.catppuccin.blue;
            background = utils.catppuccin.mantle;
            template = "{{ .UserName }}{{ if .SSHSession }}    {{ .HostName }}{{ end }}";
          }
          {
            type = "path";
            style = "powerline";
            powerline_symbol = "";
            foreground = utils.catppuccin.pink;
            background = utils.catppuccin.mantle;
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
            foreground = utils.catppuccin.lavender;
            background = utils.catppuccin.mantle;
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
            foreground = utils.catppuccin.text;
          }
        ];
      }
    ];
  };
}

{pkgs, ...}: let
  catppuccin = import ../../utils/catppuccin.nix;
in {
  # Oh-My-Posh theme and setup
  home.packages = [pkgs.oh-my-posh];

  xdg.configFile."zsh/oh-my-posh/catppuccin.json".text = builtins.toJSON {
    version = 3;
    final_space = true;

    transient_prompt = {
      background = "transparent";
      template = "\n<${catppuccin.rosewater}>  {{ .PWD }}</> ❯ ";
      foreground_templates = [
        "{{if gt .Code 0}}${catppuccin.red}{{end}}"
        "{{if eq .Code 0}}${catppuccin.mauve}{end}}"
      ];
    };

    secondary_prompt = {
      foreground = catppuccin.mauve;
      background = "transparent";
      template = "❯❯ ";
    };

    blocks = [
      {
        type = "prompt";
        alignment = "left";
        segments = [
          {
            type = "text";
            style = "plain";
            template = "\n";
          }
          {
            type = "os";
            style = "diamond";
            powerline_symbol = "";
            foreground = catppuccin.crust;
            background = catppuccin.blue;
            template = " {{.Icon}} ";
          }
          {
            type = "session";
            style = "diamond";
            powerline_symbol = "";
            foreground = catppuccin.crust;
            background = catppuccin.blue;
            template = "<b>{{ .UserName }}</b>";
          }
          {
            type = "path";
            style = "powerline";
            foreground = catppuccin.blue;
            background = catppuccin.surface0;
            powerline_symbol = "";
            properties = {
              home_icon = "~";
              style = "agnoster_full";
            };
            template = "  {{ .Path }} ";
          }
          {
            type = "git";
            foreground = catppuccin.rosewater;
            style = "plain";
            properties = {
              branch_icon = " ";
              cherry_pick_icon = " ";
              commit_icon = " ";
              fetch_status = true;
              fetch_upstream_icon = false;
              merge_icon = " ";
              no_commits_icon = " ";
              rebase_icon = " ";
              revert_icon = " ";
              tag_icon = " ";
            };
            templates = [
              " {{ .HEAD }}"
              "{{if .BranchStatus}}  {{ .BranchStatus }}{{ end }}"
              "{{if .Working.Changed}}  {{ .Working.String }}{{ end }}"
            ];
          }
        ];
      }

      {
        type = "prompt";
        alignment = "right";
        overflow = "hide";
        segments = [
          {
            type = "executiontime";
            style = "plain";
            foreground = catppuccin.rosewater;
            template = " {{ .FormattedMs }}  ";
            properties = {
              style = "austin";
              always_enabled = true;
            };
          }
          {
            type = "node";
            style = "diamond";
            leading_diamond = "";
            foreground = catppuccin.green;
            background = catppuccin.surface0;
            template = " {{ .Full }}  ";
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
            foreground_templates = [
              "{{if gt .Code 0}}${catppuccin.red}{{end}}"
              "{{if eq .Code 0}}${catppuccin.blue}{{end}}"
            ];
          }
        ];
      }
    ];
  };
}

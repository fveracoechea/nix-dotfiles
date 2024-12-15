{pkgs, ...}: let
  # https://catppuccin.com/palette
  catppuccin = {
    NAME = "oh-my-posh-catppuccin";
    pink = "#F5C2E7";
    muave = "#CBA6F7";
    blue = "#89B4FA";
    weight = "#FFFFFF";
    text = "#CDD6F4";
    peach = "#FAB387";
    yellow = "#F9E2AF";
    flamingo = "#F2CDCD";
    rosewater = "#F5E0DC";
    sky = "#89DCEB";
    sapphire = "#74C7EC";
    teal = "#94E2D5";
    maroon = "#EBA0AC";
    lavender = "#B4BEFE";
    crust = "#11111B";
    overlay = "#9399B2";
    subtext = "#CDD6F4";
    base = "#1E1E2E";
    mantle = "#181825";
    green = "#A6E3A1";
    red = "#F38BA8";
    surface0 = "#313244";
  };
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
        "{{if eq .Code 0}}${catppuccin.muave}{end}}"
      ];
    };

    secondary_prompt = {
      foreground = catppuccin.muave;
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

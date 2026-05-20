{self, ...}: {
  flake.nixosModules.vscode = {pkgs, config, lib, ...}: let
    user = config.preferences.user.name;

    theme = self.theme;
    palette = theme.palette;

    vscodeSettings = (pkgs.formats.json {}).generate "vscode-settings.json" {
      "workbench.colorTheme" = "Default Dark Modern";
      "workbench.iconTheme" = "vscode-icons";

      "editor.fontFamily" = "JetBrainsMono Nerd Font";
      "editor.fontLigatures" = true;

      "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";

      "workbench.colorCustomizations" = {
        "button.background" = palette.base0D;
        "button.hoverBackground" = palette.base0E;
        "button.foreground" = palette.base00;
        "button.secondaryBackground" = palette.base02;
        "button.secondaryHoverBackground" = palette.base03;
      };

      "editor.tokenColorCustomizations" = {
        "textMateRules" = [
          {
            scope = "comment";
            settings = {
              foreground = palette.base03;
              fontStyle = "italic";
            };
          }
          {
            scope = "string";
            settings = {
              foreground = palette.base0B;
            };
          }
          {
            scope = ["constant" "constant.numeric" "constant.character" "constant.language" "constant.other"];
            settings = {
              foreground = palette.base09;
            };
          }
          {
            scope = ["keyword" "keyword.control" "keyword.operator" "storage" "storage.type"];
            settings = {
              foreground = palette.base0E;
            };
          }
          {
            scope = ["entity.name.function" "support.function"];
            settings = {
              foreground = palette.base0D;
            };
          }
          {
            scope = ["entity.name.type" "support.type" "support.class" "storage.type"];
            settings = {
              foreground = palette.base0A;
            };
          }
          {
            scope = ["variable" "variable.parameter" "variable.other"];
            settings = {
              foreground = palette.base05;
            };
          }
        ];
      };
    };
  in {
    config = lib.mkIf config.preferences.apps.vscode {
      environment.systemPackages = [
        (pkgs.vscode-with-extensions.override {
          vscode = pkgs.vscode;
          vscodeExtensions = with pkgs.vscode-extensions; [
            bbenoist.nix
            ms-vscode-remote.remote-ssh
            ms-vscode-remote.remote-containers
            ritwickdey.liveserver
            vscode-icons-team.vscode-icons
          ];
        })
      ];

      hjem.users.${user}.files = {
        ".config/Code/User/settings.json".source = vscodeSettings;
      };
    };
  };
}

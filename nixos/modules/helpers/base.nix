# Base options: shared preferences and metadata
{
  flake.nixosModules.base = {lib, pkgs, ...}: {
    options.preferences = {
      user.name = lib.mkOption {
        type = lib.types.str;
        default = "chan";
      };

      user.fullName = lib.mkOption {
        type = lib.types.str;
        default = "ChandonJarrett";
      };

      user.email = lib.mkOption {
        type = lib.types.str;
        default = "chandonvjarrett@gmail.com";
      };

      user.initialPassword = lib.mkOption {
        type = lib.types.str;
        default = "changeme";
      };

      user.homeDirs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "Documents"
          "Downloads"
          "Media"
          "Projects"
        ];
      };

      paths.repoDir = lib.mkOption {
        type = lib.types.str;
        default = "/home/chan/nixos-config";
      };

      monitors = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            primary = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
            width = lib.mkOption {
              type = lib.types.int;
              example = 1920;
            };
            height = lib.mkOption {
              type = lib.types.int;
              example = 1080;
            };
            refreshRate = lib.mkOption {
              type = lib.types.float;
              default = 60;
            };
            scale = lib.mkOption {
              type = lib.types.float;
              default = 1;
            };
            x = lib.mkOption {
              type = lib.types.int;
              default = 0;
            };
            y = lib.mkOption {
              type = lib.types.int;
              default = 0;
            };
            enabled = lib.mkOption {
              type = lib.types.bool;
              default = true;
            };
          };
        });
        default = {};
      };

      keymap = lib.mkOption {
        type = lib.types.lazyAttrsOf (lib.types.either lib.types.attrs lib.types.package);
        default = {};
        example = {
          # Single chord
          "SUPER + Return".package = pkgs.kitty;
          # Nested chord
          "SUPER + d"."f".exec = "firefox";
        };
      };

      autostart = lib.mkOption {
        # String command or a package
        type = lib.types.listOf (lib.types.either lib.types.str lib.types.package);
        default = [];
        example = [
          "noctalia-shell"
          pkgs.noctalia-shell
        ];
      };
    };
  };
}

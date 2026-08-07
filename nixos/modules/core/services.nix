{self, ...}: {
  flake.nixosModules.services = {
    pkgs,
    config,
    lib,
    ...
  }: let
    theme = self.theme;
    palette = theme.palette;
    greeterFont = lib.elemAt (config.fonts.fontconfig.defaultFonts.sansSerif ++ ["Ubuntu Sans"]) 0;
    regreetCss = pkgs.writeText "regreet.css" ''
      /* ReGreet theme generated from theme.nix */
      @define-color background ${palette.base00};
      @define-color background-alt ${palette.base01};
      @define-color border ${palette.base02};
      @define-color foreground ${palette.base06};
      @define-color foreground-dim ${palette.base04};
      @define-color accent ${palette.base0D};

      * {
        color: @foreground;
      }

      window,
      window > box {
        background-color: @background;
      }

      window > box {
        padding: 48px;
      }

      entry,
      button,
      combobox,
      dropdown {
        background-color: @background-alt;
        border: 1px solid @border;
        border-radius: 12px;
        box-shadow: none;
        padding: 8px 12px;
      }

      button {
        background-image: none;
      }

      button:hover,
      button:focus,
      entry:focus,
      combobox:focus,
      dropdown:focus {
        border-color: @accent;
      }

      button:checked,
      button:active {
        background-color: @accent;
        color: @background;
      }

      label {
        color: @foreground;
      }

      label.dim-label {
        color: @foreground-dim;
      }

      list,
      list row {
        background-color: @background-alt;
        border-radius: 12px;
      }

      list row:selected {
        background-color: @border;
      }
    '';
  in {
    users.users.greeter = {
      isSystemUser = true;
      home = "/var/lib/greetd";
      createHome = true;
    };

    services = {
      flatpak.enable = true;
      fwupd.enable = true;
      fstrim.enable = true;
      fail2ban.enable = true;
      timesyncd.enable = true;
      upower.enable = true;
      udisks2.enable = true;
      printing.enable = config.preferences.services.printing;

      openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };

      power-profiles-daemon.enable = true;

      gvfs.enable = true;
      dbus.enable = true;

      gnome.gnome-keyring.enable = true;

      accounts-daemon.enable = true;

      dbus.packages = with pkgs; [
        gcr
        gnome-settings-daemon
      ];

      tailscale = {
        enable = true;
        extraUpFlags = ["--ssh"];
      };

      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "env HOME=/var/lib/greetd dbus-run-session ${pkgs.hyprland}/bin/start-hyprland -- -c /etc/greetd/hyprland.conf";
            user = "greeter";
          };
        };
      };
    };

    # Gnome keyring unlocks at login; acceptable on a single-user machine.
    security.pam.services.greetd.enableGnomeKeyring = true;

    systemd.tmpfiles.rules = [
      "d /var/lib/regreet 0755 greeter greeter - -"
      "d /var/log/regreet 0755 greeter greeter - -"
    ];

    services.journald.extraConfig = "SystemMaxUse=500M";

    environment.etc = {
      "greetd/regreet.css".source = regreetCss;
      "greetd/regreet.toml".text = ''
        # Generated from theme.nix — do not edit by hand.

        [appearance]
        greeting_msg = "Welcome back"

        [GTK]
        application_prefer_dark_theme = true
        theme_name = "${theme.ui.gtk.themeName}"
        icon_theme_name = "${theme.ui.gtk.iconThemeName}"
        cursor_theme_name = "${theme.ui.gtk.cursorName}"
        cursor_blink = true
        font_name = "${greeterFont}"

        [widget.clock]
        format = "%a %b %d  %H:%M"
        resolution = "500ms"
        label_width = 200
      '';
      "greetd/hyprland.conf".text = ''
        exec-once = ${pkgs.regreet}/bin/regreet; hyprctl dispatch exit

        env = GTK_USE_PORTAL,0
        env = GDK_DEBUG,no-portals

        misc {
          disable_hyprland_logo = true
          disable_splash_rendering = true
          disable_hyprland_guiutils_check = true
        }
      '';
    };
  };
}

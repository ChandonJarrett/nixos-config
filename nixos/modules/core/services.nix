{...}: {
  flake.nixosModules.services = {pkgs, ...}: {
    users.users.greeter = {
      isSystemUser = true;
      home = "/var/lib/greetd";
      createHome = true;
    };

    services = {
      flatpak.enable = true;
      fwupd.enable = true;
      fstrim.enable = true;
      openssh.enable = true;
      timesyncd.enable = true;
      upower.enable = true;
      udisks2.enable = true;
      printing.enable = true;

      power-profiles-daemon.enable = true;

      gvfs.enable = true;
      dbus.enable = true;

      gnome.gnome-keyring.enable = true;

      # ReGreet relies on AccountsService for user listing.
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

    security.pam.services.greetd.enableGnomeKeyring = true;

    # ReGreet needs writable state and log directories.
    systemd.tmpfiles.rules = [
      "d /var/lib/regreet 0755 greeter greeter - -"
      "d /var/log/regreet 0755 greeter greeter - -"
    ];

    environment.etc = {
      "greetd/regreet.css".source = ./regreet-theme.css;
      "greetd/regreet.toml".text = ''
        # Basic ReGreet config with GTK theming and a simple clock.
        # Keep this file in sync with any theme assets under /etc/greetd.

        [appearance]
        greeting_msg = "Welcome back"

        [GTK]
        application_prefer_dark_theme = true
        theme_name = "Orchis-Purple-Dark"
        icon_theme_name = "Papirus-Dark"
        cursor_theme_name = "Bibata-Modern-Ice"
        cursor_blink = true
        font_name = "Ubuntu Sans"

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

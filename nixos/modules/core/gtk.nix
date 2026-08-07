{
  flake.nixosModules.gtk = {
    pkgs,
    lib,
    config,
    self,
    ...
  }: let
    theme = self.theme;

    themeName = theme.ui.gtk.themeName;
    themePackage = pkgs.orchis-theme;

    iconThemeName = theme.ui.gtk.iconThemeName;
    iconThemePackage = pkgs.papirus-icon-theme.override {color = theme.ui.gtk.iconColor;};

    cursorName = theme.ui.gtk.cursorName;
    cursorSize = theme.ui.gtk.cursorSize;
    cursorPackage = pkgs.bibata-cursors;

    gtkSettings = ''
      [Settings]
      gtk-theme-name=${themeName}
      gtk-icon-theme-name=${iconThemeName}
      gtk-cursor-theme-name=${cursorName}
      gtk-cursor-theme-size=${toString cursorSize}
      gtk-application-prefer-dark-theme=1
    '';
  in {
    environment.etc = {
      "xdg/gtk-3.0/settings.ini".text = gtkSettings;
      "xdg/gtk-4.0/settings.ini".text = gtkSettings;
      "xdg/gtk-4.0/gtk.css".source = "${themePackage}/share/themes/${themeName}/gtk-4.0/gtk.css";
      "xdg/gtk-4.0/gtk-dark.css".source = "${themePackage}/share/themes/${themeName}/gtk-4.0/gtk-dark.css";
    };

    environment.sessionVariables = {
      GTK_THEME = themeName;
      GTK_ICON_THEME = iconThemeName;
      XCURSOR_THEME = cursorName;
      XCURSOR_SIZE = toString cursorSize;
    };

    programs.dconf = {
      enable = lib.mkDefault true;
      profiles.user.databases = [
        {
          settings."org/gnome/desktop/interface" = {
            gtk-theme = themeName;
            icon-theme = iconThemeName;
            cursor-theme = cursorName;
            cursor-size = lib.gvariant.mkUint32 cursorSize;
            color-scheme = "prefer-dark";
          };
        }
      ];
    };

    environment.systemPackages = with pkgs; [
      themePackage
      iconThemePackage
      cursorPackage
      gtk3
      gtk4
      gnome-themes-extra
      glib
    ];

    systemd.tmpfiles.rules = let
      user = config.preferences.user.name;
    in [
      "d /home/${user}/.local/share/themes 0755 ${user} users - -"
      "d /home/${user}/.local/share/icons 0755 ${user} users - -"
      "L /home/${user}/.local/share/themes/${themeName} - - - - ${themePackage}/share/themes/${themeName}"
      "L /home/${user}/.local/share/icons/${iconThemeName} - - - - ${iconThemePackage}/share/icons/${iconThemeName}"
      "L /home/${user}/.local/share/icons/${cursorName} - - - - ${cursorPackage}/share/icons/${cursorName}"
    ];

    systemd.user.services."flatpak-theme-override" = {
      wantedBy = ["default.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.flatpak}/bin/flatpak override --user --filesystem=xdg-data/themes:ro --filesystem=xdg-data/icons:ro";
      };
    };
  };
}

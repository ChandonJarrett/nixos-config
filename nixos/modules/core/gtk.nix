{
  flake.nixosModules.gtk = { pkgs, lib, self, ... }: let
    theme = self.theme;

    themeName = theme.ui.gtk.themeName;
    themePackage = pkgs.orchis-theme;

    iconThemeName = theme.ui.gtk.iconThemeName;
    iconThemePackage = pkgs.papirus-icon-theme.override { color = theme.ui.gtk.iconColor; };

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
      # Fix GTK4 / libadwaita theming
      "xdg/gtk-4.0/gtk.css".source = "${themePackage}/share/themes/${themeName}/gtk-4.0/gtk.css";
      "xdg/gtk-4.0/gtk-dark.css".source = "${themePackage}/share/themes/${themeName}/gtk-4.0/gtk-dark.css";
    };

    environment.sessionVariables = {
      GTK_THEME = themeName;
      GTK_ICON_THEME = iconThemeName;
      XCURSOR_THEME = cursorName;
      XCURSOR_SIZE = toString cursorSize;
      # also need `exec-once = hyprctl setcursor Bibata-Modern-Ice 18` in Hyprland config
    };

    programs.dconf = {
      enable = lib.mkDefault true;
      profiles.user.databases = [{
        settings."org/gnome/desktop/interface" = {
          gtk-theme    = themeName;
          icon-theme   = iconThemeName;
          cursor-theme = cursorName;
          cursor-size  = lib.gvariant.mkUint32 cursorSize;
          color-scheme = "prefer-dark";
        };
      }];
    };

    environment.systemPackages = with pkgs; [
      themePackage
      iconThemePackage
      cursorPackage
      gtk3
      gtk4
      gnome-themes-extra
    ];

  };
}

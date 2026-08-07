{self, ...}: {
  flake.nixosModules.desktop = {
    pkgs,
    config,
    lib,
    ...
  }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
    user = config.preferences.user.name;

    theme = self.theme;
    palette = theme.palette;
    paletteNoHash = theme.paletteNoHash;
    semantic = theme.semantic;
    semanticNoHash = theme.semanticNoHash;

    rgba = color: alpha: "rgba(${color}${alpha})";
    fuzzelColor = color: alpha: "${color}${alpha}";

    appLauncher = pkgs.writeShellScriptBin "app-launcher" ''
      exec fuzzel
    '';

    clipboardPicker = pkgs.writeShellScriptBin "clipboard-picker" ''
      exec cliphist list | fuzzel --dmenu --prompt "Clipboard: " | cliphist decode | wl-copy
    '';

    screenshotTool = pkgs.writeShellScriptBin "screenshot-tool" ''
      exec grim -g "$(slurp)" - | swappy -f -
    '';
  in {
    imports = [
      self.nixosModules.hyprland
      self.nixosModules.gtk
      self.nixosModules.audio
    ];

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = ["gtk"];
        hyprland.default = ["gtk" "hyprland"];
      };
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    services.libinput.enable = true;

    home.programs.hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";

        general = {
          gaps_in = 6;
          gaps_out = 12;
          border_size = 2;

          "col.active_border" = "${rgba paletteNoHash.base0D "ff"} ${rgba paletteNoHash.base0E "ff"} 45deg";
          "col.inactive_border" = rgba paletteNoHash.base02 "aa";

          layout = "dwindle";
          resize_on_border = true;
          allow_tearing = false;
        };

        input = {
          kb_layout = "us";
          kb_options = "caps:escape";
          follow_mouse = 1;
          sensitivity = 0;

          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
            tap-to-click = true;
            clickfinger_behavior = true;
            scroll_factor = 0.8;
          };
        };

        decoration = {
          rounding = 12;

          active_opacity = 0.92;
          inactive_opacity = 0.85;
          fullscreen_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 18;
            render_power = 3;
            color = rgba paletteNoHash.base00 "66";
            color_inactive = rgba paletteNoHash.base00 "44";
          };

          blur = {
            enabled = true;
            size = 5;
            passes = 2;
            vibrancy = 0.18;
            contrast = 1.05;
            brightness = 0.95;
            noise = 0.01;
            new_optimizations = true;
            xray = false;
          };
        };

        animations = {
          enabled = true;

          bezier = [
            "smooth, 0.22, 0.61, 0.36, 1.0"
            "snappy, 0.16, 1.0, 0.3, 1.0"
          ];

          animation = [
            "windows, 1, 4, smooth, slide"
            "windowsOut, 1, 4, smooth, slide"
            "border, 1, 6, smooth"
            "fade, 1, 6, smooth"
            "workspaces, 1, 5, snappy"
          ];
        };

        dwindle = {
          preserve_split = true;
          smart_split = false;
          smart_resizing = true;
        };

        gestures = {
          workspace_swipe_touch = true;
          workspace_swipe_distance = 280;
          workspace_swipe_invert = true;
          workspace_swipe_min_speed_to_force = 30;
          workspace_swipe_cancel_ratio = 0.5;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          vrr = 1;

          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;

          focus_on_activate = true;
          animate_manual_resizes = true;
          animate_mouse_windowdragging = true;
        };

        debug = {
          vfr = true;
        };

        xwayland = {
          force_zero_scaling = true;
        };

        cursor = {
          no_hardware_cursors = false;
          inactive_timeout = 10;
        };

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };
      };

      extraConfig = ''
        bind = $mod, 1, workspace, 1
        bind = $mod, 2, workspace, 2
        bind = $mod, 3, workspace, 3
        bind = $mod, 4, workspace, 4
        bind = $mod, 5, workspace, 5
        bind = $mod, 6, workspace, 6
        bind = $mod, 7, workspace, 7
        bind = $mod, 8, workspace, 8
        bind = $mod, 9, workspace, 9
        bind = $mod, 0, workspace, 10

        bind = $mod SHIFT, 1, movetoworkspacesilent, 1
        bind = $mod SHIFT, 2, movetoworkspacesilent, 2
        bind = $mod SHIFT, 3, movetoworkspacesilent, 3
        bind = $mod SHIFT, 4, movetoworkspacesilent, 4
        bind = $mod SHIFT, 5, movetoworkspacesilent, 5
        bind = $mod SHIFT, 6, movetoworkspacesilent, 6
        bind = $mod SHIFT, 7, movetoworkspacesilent, 7
        bind = $mod SHIFT, 8, movetoworkspacesilent, 8
        bind = $mod SHIFT, 9, movetoworkspacesilent, 9
        bind = $mod SHIFT, 0, movetoworkspacesilent, 10

        bind = $mod, q, killactive
        bind = $mod, m, exit
        bind = $mod, f, fullscreen
        bind = $mod SHIFT, f, togglefloating
        bind = $mod, p, pseudo
        bind = $mod, n, layoutmsg, togglesplit

        bind = $mod, h, movefocus, l
        bind = $mod, l, movefocus, r
        bind = $mod, k, movefocus, u
        bind = $mod, j, movefocus, d

        bind = $mod SHIFT, h, movewindow, l
        bind = $mod SHIFT, l, movewindow, r
        bind = $mod SHIFT, k, movewindow, u
        bind = $mod SHIFT, j, movewindow, d

        bind = $mod CTRL, h, resizeactive, -20 0
        bind = $mod CTRL, l, resizeactive, 20 0
        bind = $mod CTRL, k, resizeactive, 0 -20
        bind = $mod CTRL, j, resizeactive, 0 20

        bind = $mod, comma, focusmonitor, -1
        bind = $mod, period, focusmonitor, +1
        bind = $mod SHIFT, comma, movewindow, mon:-1
        bind = $mod SHIFT, period, movewindow, mon:+1
        bind = $mod CTRL, comma, movecurrentworkspacetomonitor, -1
        bind = $mod CTRL, period, movecurrentworkspacetomonitor, +1

        bindm = $mod, mouse:272, movewindow
        bindm = $mod, mouse:273, resizewindow
      '';
    };

    home.programs.hyprland.settings.monitor = let
      monitors = config.preferences.monitors;
      toMonitor = name: mon:
        if !mon.enabled
        then "${name},disable"
        else "${name},${toString mon.width}x${toString mon.height}@${toString mon.refreshRate},${toString mon.x}x${toString mon.y},${toString mon.scale}";
      # Hyprland treats the FIRST monitor line as primary, and attrset
      # iteration order is unspecified — so sort primary monitors first.
      monitorList = lib.mapAttrsToList (name: mon: {inherit name mon;}) monitors;
      ordered = (builtins.filter (m: m.mon.primary) monitorList) ++ (builtins.filter (m: !m.mon.primary) monitorList);
    in
      if monitors == {}
      then [",preferred,auto,1"]
      else map (m: toMonitor m.name m.mon) ordered;

    preferences.keymap = {
      "SUPER + t".package = self.packages.${pkgs.stdenv.hostPlatform.system}.terminal;
      "SUPER + a".package = appLauncher;
      "SUPER + v".package = clipboardPicker;
      "SUPER + s".package = screenshotTool;
    };

    preferences.autostart = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia-shell
      "hyprctl setcursor ${theme.ui.gtk.cursorName} ${toString theme.ui.gtk.cursorSize}"
      "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    ];

    hjem.users.${user}.files = {
      ".config/noctalia/colors.json".text = builtins.toJSON theme.ui.noctalia;

      ".config/fuzzel/fuzzel.ini".text = ''
        [main]
        font=JetBrainsMono Nerd Font:size=11
        dpi-aware=yes

        prompt=
        terminal=kitty -e

        icons-enabled=yes
        icon-theme=${theme.ui.gtk.iconThemeName}

        layer=overlay
        width=42
        lines=12

        horizontal-pad=18
        vertical-pad=14
        inner-pad=8

        image-size-ratio=0.45

        fields=name,generic,comment,categories,filename,keywords
        match-mode=fzf

        exit-on-keyboard-focus-loss=yes

        [colors]
        background=${fuzzelColor paletteNoHash.base00 "dd"}
        text=${fuzzelColor paletteNoHash.base05 "ff"}
        match=${fuzzelColor paletteNoHash.base0D "ff"}

        selection=${fuzzelColor paletteNoHash.base02 "ee"}
        selection-text=${fuzzelColor paletteNoHash.base07 "ff"}
        selection-match=${fuzzelColor paletteNoHash.base0E "ff"}

        border=${fuzzelColor paletteNoHash.base0D "bb"}

        [border]
        width=2
        radius=12

        [dmenu]
        exit-immediately-if-empty=yes
      '';
    };

    # Clipboard history as a real user unit (hjem files can't be enabled by
    # systemd — a plain file in ~/.config/systemd/user/ is never started).
    systemd.user.services.cliphist = {
      description = "Clipboard history (cliphist)";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
        Restart = "on-failure";
        RestartSec = 3;
      };
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = with pkgs; [
      selfpkgs.terminal
      selfpkgs.noctalia-shell

      mpv
      imv
      loupe
      evince
      file-roller
      pavucontrol
      fuzzel

      wl-clipboard
      cliphist
      grim
      slurp
      swappy

      wf-recorder
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      ubuntu-sans
      noto-fonts-color-emoji
    ];

    fonts.fontconfig.defaultFonts = {
      serif = ["Ubuntu Sans"];
      sansSerif = ["Ubuntu Sans"];
      monospace = ["JetBrainsMono Nerd Font"];
      emoji = ["Noto Color Emoji"];
    };
  };
}

{
  self,
  inputs,
  config,
  ...
}: let
  theme = config.flake.theme.palette;
  themeNoHash = config.flake.theme.paletteNoHash;
in {
  flake.wrappersModules.kitty = {
    config,
    lib,
    ...
  }: {
    options.shell = lib.mkOption {
      type = lib.types.str;
      default = "";
    };

    config = {
      args = lib.mkAfter (lib.optionals (config.shell != "") [config.shell]);

      settings = {
        enable_audio_bell = "no";
        visual_bell_duration = "0.05";
        window_alert_on_bell = "yes";
        bell_on_tab = "󰂞 ";

        confirm_os_window_close = 0;
        scrollback_lines = 20000;
        wheel_scroll_multiplier = 3;
        touch_scroll_multiplier = 3;
        mouse_hide_wait = 60;
        copy_on_select = "clipboard";

        font_size = 15;
        font_family = "JetBrainsMono Nerd Font";
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";

        adjust_line_height = "100%";
        adjust_column_width = "100%";

        cursor_shape = "beam";
        cursor_beam_thickness = 1.8;
        cursor_blink_interval = 0.55;
        cursor_stop_blinking_after = 15;
        cursor_text_color = "background";
        cursor_trail = 3;

        url_color = theme.base0C;
        url_style = "single";
        open_url_with = "default";

        allow_remote_control = "yes";
        listen_on = "unix:/tmp/kitty";
        shell_integration = "enabled";
        allow_hyperlinks = "yes";

        placement_strategy = "center";
        remember_window_size = "yes";
        initial_window_width = 1200;
        initial_window_height = 760;

        window_padding_width = 10;
        single_window_margin_width = 0;
        window_margin_width = 0;

        active_border_color = theme.base0D;
        inactive_border_color = theme.base02;
        bell_border_color = theme.base0A;
        window_border_width = "1pt";
        draw_minimal_borders = "yes";

        tab_bar_edge = "bottom";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_bar_min_tabs = 2;
        tab_title_template = "{fmt.fg._${themeNoHash.base0D}}{index}:{fmt.fg.default} {title}";
        active_tab_title_template = "{fmt.bold}{fmt.fg._${themeNoHash.base07}}{index}: {title}{fmt.bold.end}";

        active_tab_font_style = "bold";
        inactive_tab_font_style = "normal";

        background = theme.base00;
        foreground = theme.base05;

        background_opacity = "0.8";
        dynamic_background_opacity = "yes";

        cursor = theme.base07;

        selection_foreground = theme.base07;
        selection_background = theme.base02;

        active_tab_foreground = theme.base00;
        active_tab_background = theme.base0D;
        inactive_tab_foreground = theme.base04;
        inactive_tab_background = theme.base01;
        tab_bar_background = theme.base00;

        mark1_foreground = theme.base00;
        mark1_background = theme.base0A;
        mark2_foreground = theme.base00;
        mark2_background = theme.base0D;
        mark3_foreground = theme.base00;
        mark3_background = theme.base0E;

        color0 = theme.base00;
        color8 = theme.base03;

        color1 = theme.base08;
        color9 = theme.base08;

        color2 = theme.base0B;
        color10 = theme.base0B;

        color3 = theme.base0A;
        color11 = theme.base0A;

        color4 = theme.base0D;
        color12 = theme.base0D;

        color5 = theme.base0E;
        color13 = theme.base0E;

        color6 = theme.base0C;
        color14 = theme.base0C;

        color7 = theme.base05;
        color15 = theme.base07;

        map = [
          "alt+1 goto_tab 1"
          "alt+2 goto_tab 2"
          "alt+3 goto_tab 3"
          "alt+4 goto_tab 4"
          "alt+5 goto_tab 5"
          "alt+6 goto_tab 6"
          "alt+7 goto_tab 7"
          "alt+8 goto_tab 8"
          "alt+9 goto_tab 9"

          "ctrl+shift+w close_tab"
          "ctrl+shift+t new_tab"
          "ctrl+t new_tab_with_cwd"

          "ctrl+shift+enter new_window_with_cwd"
          "ctrl+shift+backspace close_window"

          "ctrl+shift+h neighboring_window left"
          "ctrl+shift+j neighboring_window down"
          "ctrl+shift+k neighboring_window up"
          "ctrl+shift+l neighboring_window right"

          "ctrl+shift+left resize_window narrower 5"
          "ctrl+shift+right resize_window wider 5"
          "ctrl+shift+up resize_window taller 3"
          "ctrl+shift+down resize_window shorter 3"

          "ctrl+shift+f launch --type=overlay --stdin-source=@screen_scrollback nvim -"
          "ctrl+shift+g show_scrollback"

          "ctrl+shift+c copy_to_clipboard"
          "ctrl+shift+v paste_from_clipboard"
          "ctrl+shift+plus change_font_size all +1.0"
          "ctrl+shift+minus change_font_size all -1.0"
          "ctrl+shift+0 change_font_size all 0"
        ];
      };
    };
  };

  perSystem = {pkgs, ...}: {
    packages.kitty =
      (inputs.wrappers.wrapperModules.kitty.apply {
        inherit pkgs;
        imports = [self.wrappersModules.kitty];
      }).wrapper;
  };
}
{
  inputs,
  lib,
  config,
  ...
}: let
  theme = config.flake.theme;
  palette = theme.palette;
in {
  perSystem = {pkgs, ...}: let
    conf = (pkgs.formats.toml {}).generate "starship.toml" {
      add_newline = true;
      palette = "chan";

      format = lib.replaceStrings ["\n"] [""] ''
        [╭─](bold fg:purple_bright)
        [](fg:base0E)
        $os
        [ ](fg:base0E bg:base0D)
        $directory
        [ ](fg:base0D bg:purple_dark)
        $git_branch
        $git_status
        [ ](fg:purple_dark bg:purple_deep)
        $nix_shell
        $direnv
        [](fg:purple_deep)
        $fill
        $cmd_duration
        $line_break
        [╰─](bold fg:purple_bright)
        $character
      '';

      
      palettes.chan = {
        base00 = palette.base00;
        base01 = palette.base01;
        base02 = palette.base02;
        base03 = palette.base03;
        base04 = palette.base04;
        base05 = palette.base05;
        base06 = palette.base06;
        base07 = palette.base07;
        base08 = palette.base08;
        base09 = palette.base09;
        base0a = palette.base0A;
        base0b = palette.base0B;
        base0c = palette.base0C;
        base0d = palette.base0D;
        base0e = palette.base0E;
        base0f = palette.base0F;

        # Extra purple shades
        purple_bright = theme.ui.starship.purpleBright;
        purple_dark = theme.ui.starship.purpleDark;
        purple_deep = theme.ui.starship.purpleDeep;
      };

      fill.symbol = " ";

      os = {
        disabled = false;
        format = "[ ](fg:purple_deep bg:base0E)";
      };

      directory = {
        format = "[$path ](bold fg:base07 bg:base0D)";
        truncation_length = 3;
        truncation_symbol = "../";
        home_symbol = "~";
      };

      git_branch = {
        symbol = " ";
        format = "[$symbol$branch](bold fg:purple_bright bg:purple_dark)";
      };

      git_status = {
        format = "[ $all_status$ahead_behind](bold fg:purple_bright bg:purple_dark)";
      };

      nix_shell = {
        symbol = " ";
        format = "[$symbol$state ](fg:base04 bg:purple_deep)";
      };

      direnv = {
        disabled = false;
        format = "[ direnv ](fg:base04 bg:purple_deep)[](fg:purple_deep)";
      };

      cmd_duration = {
        min_time = 500;
        show_milliseconds = true;
        format = "[](fg:base02)[$duration](fg:base0D bg:base02)[ ](fg:base02)";
      };

      character = {
        success_symbol = "[](bold fg:purple_bright)";
        error_symbol   = "[](bold fg:base08)";
      };

      package.disabled = true;
      nodejs.disabled = true;
      python.disabled = true;
      rust.disabled = true;
      golang.disabled = true;
      java.disabled = true;
      docker_context.disabled = true;
      kubernetes.disabled = true;
    };
  in {
    packages.starship = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.starship;
      env.STARSHIP_CONFIG = "${conf}";
    };
  };
}
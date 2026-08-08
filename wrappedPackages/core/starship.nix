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
    conf = pkgs.replaceVars ./starship.toml {
      inherit
        (palette)
        base00
        base01
        base02
        base03
        base04
        base05
        base06
        base07
        base08
        base09
        base0A
        base0B
        base0C
        base0D
        base0E
        base0F
        ;
      purpleBright = theme.ui.starship.purpleBright;
      purpleDark = theme.ui.starship.purpleDark;
      purpleDeep = theme.ui.starship.purpleDeep;
    };
  in {
    packages.starship = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.starship;
      env.STARSHIP_CONFIG = "${conf}";
    };
  };
}

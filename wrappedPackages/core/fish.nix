{
  inputs,
  lib,
  config,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    theme = config.flake.theme.palette;

    lf = self'.packages.lf;
    starship = self'.packages.starship;
    neovim = self'.packages.neovim;

    fishConf = pkgs.replaceVars ./fish/config.fish {
      neovim = lib.getExe neovim;
      starship = lib.getExe starship;
      zoxide = lib.getExe pkgs.zoxide;
      lf = lib.getExe lf;
      inherit
        (theme)
        base00
        base01
        base05
        base07
        base0A
        base0B
        base0C
        base0D
        base0E
        ;
    };
  in {
    packages.fish = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.fish;

      runtimeInputs = with pkgs; [
        zoxide
        starship
        direnv
        fzf
        fd
        ripgrep
        bat
        eza
        jq
        delta
        unzip
        p7zip
        unrar
        less
      ];

      flags = {
        "-C" = "source ${fishConf}";
      };
    };
  };
}

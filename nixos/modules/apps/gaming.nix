{
  flake.nixosModules.gaming = {
    pkgs,
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.preferences.apps.gaming {
      programs = {
        steam = {
          enable = true;
          extraCompatPackages = [pkgs.proton-ge-bin];
        };

        gamemode.enable = true;
      };

      environment.systemPackages = [pkgs.mangohud pkgs.winetricks];
    };
  };
}

{
  flake.nixosModules.gimp = {pkgs, config, lib, ...}: {
    config = lib.mkIf config.preferences.apps.gimp {
      environment.systemPackages = [
        pkgs.gimp3
      ];
    };
  };
}

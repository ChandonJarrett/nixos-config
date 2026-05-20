{...}: {
  flake.nixosModules.obsidian = {pkgs, config, lib, ...}: {
    config = lib.mkIf config.preferences.apps.obsidian {
      environment.systemPackages = [
        pkgs.obsidian
      ];
    };
  };
}

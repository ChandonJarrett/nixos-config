{
  flake.nixosModules.chromium = {config, lib, ...}: {
    config = lib.mkIf config.preferences.apps.chromium {
      programs.chromium.enable = true;
    };
  };
}

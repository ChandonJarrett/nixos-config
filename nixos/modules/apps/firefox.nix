{
  flake.nixosModules.firefox = {pkgs, config, lib, ...}: {
    config = lib.mkIf config.preferences.apps.firefox {
      programs.firefox = {
        enable = true;

        preferences = {
          "browser.tabs.unloadOnLowMemory" = true;
          "browser.cache.memory.enable" = false;
        };
        policies = {
          DisableTelemetry = true;
        };
      };

      preferences.keymap = {
        "SUPER + w".package = pkgs.firefox;
      };
    };
  };
}

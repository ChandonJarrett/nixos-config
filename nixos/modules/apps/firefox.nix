{
  flake.nixosModules.firefox = {
    pkgs,
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.preferences.apps.firefox {
      programs.firefox = {
        enable = true;

        preferences = {
          "browser.tabs.unloadOnLowMemory" = true;
          "browser.cache.memory.enable" = false;
        };
        policies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;

          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          DNSOverHTTPS = {
            Enabled = true;
            Locked = true;
          };
          HTTPSOnlyMode = "enabled";

          # Install uBlock Origin from AMO on first launch
          ExtensionSettings = {
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        };
      };

      preferences.keymap = {
        "SUPER + w".package = pkgs.firefox;
      };
    };
  };
}

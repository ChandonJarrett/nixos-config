{
  inputs,
  self,
  ...
}: {
  # Expose a flake output for `nixos-rebuild --flake .#thinkpad`
  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs self;
    };
    modules = [
      self.nixosModules.hostThinkpad
    ];
  };

  flake.nixosModules.hostThinkpad = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.base
      self.nixosModules.system
      self.nixosModules.desktop
      self.nixosModules.apps

      self.nixosModules.hostShared
      ./hardware-configuration.nix
    ];

    networking.hostName = "thinkpad";

    # Developer toolchains (java/mobile intentionally off).
    preferences.devtools = {
      node = true;
      python = true;
      rust = true;
      go = true;
      cc = true;
    };

    preferences.monitors = {
      "eDP-1" = {
        primary = true;
        width = 1920;
        height = 1200;
        refreshRate = 59.999;
        x = 0;
        y = 0;
        scale = 1.25;
      };
    };

    home.programs.hyprland.settings.input.touchpad.natural_scroll = true;

    boot.loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      devices = ["nodev"];
    };

    networking.networkmanager.wifi.powersave = false;

    services = {
      libinput.enable = true;
      fprintd.enable = true;

      tlp = {
        enable = true;
        settings = {
          PLATFORM_PROFILE_ON_AC = "performance";
          PLATFORM_PROFILE_ON_BAT = "low-power";
        };
      };
      power-profiles-daemon.enable = lib.mkForce false;
    };

    security.pam.services = {
      login.fprintAuth = true;
      sudo.fprintAuth = true;
    };

    environment.systemPackages = with pkgs; [
      brightnessctl
    ];

    system.stateVersion = "25.11";
  };
}

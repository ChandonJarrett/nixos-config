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

  flake.nixosModules.hostThinkpad = {pkgs, ...}: {
    imports = [
      self.nixosModules.base
      self.nixosModules.system
      self.nixosModules.desktop
      self.nixosModules.apps
      
      self.nixosModules.hostShared
      ./hardware-configuration.nix
    ];

    networking.hostName = "thinkpad";

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
      devices = [ "nodev" ];
    };

    services = {
      libinput.enable = true;
      fprintd.enable = true;
    };

    environment.systemPackages = with pkgs; [
      brightnessctl
    ];

    system.stateVersion = "25.11";
  };
}
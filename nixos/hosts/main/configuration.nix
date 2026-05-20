{
  inputs,
  self,
  ...
}: {
  # Expose a flake output for `nixos-rebuild --flake .#main`
  flake.nixosConfigurations.main = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs self;
    };
    modules = [
      self.nixosModules.hostMain
    ];
  };

  flake.nixosModules.hostMain = {pkgs, ...}: {
    imports = [
      self.nixosModules.base
      self.nixosModules.system
      self.nixosModules.desktop
      self.nixosModules.apps
      
      self.nixosModules.hostShared
      ./hardware-configuration.nix
    ];

    networking.hostName = "main";

    preferences.apps.virtualization = true;

    boot.loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      devices = [ "nodev" ];
    };

    system.stateVersion = "25.11";
  };
}
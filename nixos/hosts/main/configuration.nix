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

    # Bootstrap password until .agenix/userPassword.main.age exists; run
    # ./.agenix/rotate-password.sh on the main machine to replace it.
    preferences.user.initialPassword = "changeme";

    preferences.apps.virtualization = true;
    preferences.apps.gaming = true;

    # Minimal toolchain set on the desktop host (opt-in defaults).
    preferences.devtools.cc = true;

    boot.loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      devices = ["nodev"];
    };

    system.stateVersion = "25.11";
  };
}

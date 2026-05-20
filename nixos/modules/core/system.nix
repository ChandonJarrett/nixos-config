{self, ...}: {
  flake.nixosModules.system = {
    imports = [
      self.nixosModules.hjem
      self.nixosModules.nix
      self.nixosModules.shell
      self.nixosModules.network
      self.nixosModules.services
      self.nixosModules.locale
      self.nixosModules.users
      self.nixosModules.devtools
    ];
  };
}

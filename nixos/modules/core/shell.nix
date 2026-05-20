{lib, self, ...}: {
  flake.nixosModules.shell = {pkgs, config, ...}: let
    repoDir = config.preferences.paths.repoDir;
  in {
    programs.fish = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.fish;
      shellAliases = {
        config = "cd ${repoDir}";
        snrs = "sudo nixos-rebuild switch --flake";
      };
    };

    programs.starship = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.starship;
    };
  };
}

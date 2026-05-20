{inputs, ...}: {
  flake.nixosModules.nix = {pkgs, config, ...}: let
    repoDir = config.preferences.paths.repoDir;
  in {
    imports = [
      inputs.nix-index-database.nixosModules.nix-index
    ];

    programs.nix-index-database.comma.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      download-buffer-size = 524288000;
      trusted-users = ["root" "@wheel"];
    };

    programs.nix-ld.enable = true;
    nixpkgs.config.allowUnfree = true;

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 5";
      };
      flake = repoDir;
    };

    environment.systemPackages = with pkgs; [
      nixd
      statix
      alejandra
      manix
      nix-inspect
    ];
  };
}

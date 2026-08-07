{inputs, ...}: {
  flake.nixosModules.nix = {
    pkgs,
    config,
    ...
  }: let
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
      # 128 MiB per download worker; the old 500 MiB ballooned RAM when
      # max-jobs parallel downloads were in flight.
      download-buffer-size = 134217728;
      trusted-users = ["root" "@wheel"];
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      randomizedDelaySec = "6h";
      options = "--delete-older-than 7d";
    };
    nix.optimise.automatic = true;

    programs.nix-ld.enable = true;
    nixpkgs.config.allowUnfree = true;

    programs.nh = {
      enable = true;
      clean.enable = false;
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

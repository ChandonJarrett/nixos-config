{inputs, ...}: {
  imports = [
    inputs.wrapper-modules.flakeModules.wrappers
  ];

  options = {
    flake = inputs.flake-parts.lib.mkSubmoduleOptions {
      wrappersModules = inputs.nixpkgs.lib.mkOption {
        default = {};
      };
    };
  };

  config = {
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    perSystem = {
      system,
      pkgs,
      ...
    }: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      formatter = pkgs.alejandra;

      # Used by .agenix/rotate-password.sh so it runs this flake's own
      # nixpkgs instead of the nixpkgs registry.
      packages = {
        mkpasswd = pkgs.whois;
        age = pkgs.age;
      };
    };
  };
}

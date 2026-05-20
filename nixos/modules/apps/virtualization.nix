{
  flake.nixosModules.virtualization = {config, lib, ...}: {
    config = lib.mkIf config.preferences.apps.virtualization {
      virtualisation = {
        libvirtd.enable = true;

        docker = {
          enable = true;
          enableOnBoot = true;
        };

        podman = {
          enable = false;
        };
      };

      programs.virt-manager.enable = true;
    };
  };
}

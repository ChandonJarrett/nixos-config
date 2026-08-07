{
  flake.nixosModules.virtualization = {
    config,
    lib,
    ...
  }: {
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

      # The docker/libvirtd groups only exist when the modules above are enabled.
      users.users.${config.preferences.user.name}.extraGroups = [
        "docker"
        "libvirtd"
      ];
    };
  };
}

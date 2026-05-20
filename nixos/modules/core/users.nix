{self, ...}: {
  flake.nixosModules.users = {pkgs, config, lib, ...}: let
    user = config.preferences.user.name;
    fullName = config.preferences.user.fullName;
    email = config.preferences.user.email;
    initialPassword = config.preferences.user.initialPassword;
  in {
    users.users.${user} = {
      isNormalUser = true;
      description = fullName;
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "libvirtd"
        "video"
        "audio"
      ];
      shell = self.packages.${pkgs.stdenv.hostPlatform.system}.fish;
      initialPassword = initialPassword; # run `passwd` on first login
    };

    systemd.tmpfiles.rules =
      builtins.map
        (dir: "d /home/${user}/${dir} 0700 ${user} users - -")
        config.preferences.user.homeDirs;

  };
}

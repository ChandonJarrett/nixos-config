{self, ...}: {
  flake.nixosModules.users = {
    pkgs,
    config,
    lib,
    ...
  }: let
    user = config.preferences.user.name;
    fullName = config.preferences.user.fullName;
    initialPassword = config.preferences.user.initialPassword;
    hasPasswordSecret = config.age.secrets ? userPassword;
  in {
    users.users.${user} = {
      isNormalUser = true;
      description = fullName;
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "audio"
      ];
      shell = self.packages.${pkgs.stdenv.hostPlatform.system}.fish;
      hashedPasswordFile = lib.mkIf hasPasswordSecret config.age.secrets.userPassword.path;
      initialPassword = lib.mkIf (!hasPasswordSecret) initialPassword;
    };

    warnings = lib.mkIf (!hasPasswordSecret && initialPassword == null) [
      ''
        No password configured for user '${user}': there is no
        .agenix/userPassword.${config.networking.hostName}.age secret and
        preferences.user.initialPassword is unset, so the account would have
        no password (login disabled). Generate the secret with
        ./.agenix/rotate-password.sh or set preferences.user.initialPassword.
      ''
    ];

    systemd.tmpfiles.rules =
      builtins.map
      (dir: "d /home/${user}/${dir} 0700 ${user} users - -")
      config.preferences.user.homeDirs;
  };
}

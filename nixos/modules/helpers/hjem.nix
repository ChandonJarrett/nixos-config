# Hjem integration for writing user-level config files declaratively
{inputs, ...}: {
  flake.nixosModules.hjem = {config, ...}: let
    user = config.preferences.user.name;
  in {
    imports = [
      inputs.hjem.nixosModules.default
    ];

    config.hjem = {
      users."${user}" = {
        enable = true;
        directory = "/home/${user}";
        user = "${user}";
      };

      # Overwrite files managed by Hjem without prompting
      clobberByDefault = true;
    };
  };
}

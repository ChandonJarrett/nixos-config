{inputs, ...}: {
  flake.nixosModules.secrets = {
    config,
    lib,
    ...
  }: let
    secretFile = ./.agenix + "/userPassword.${config.networking.hostName}.age";
    hasSecret = builtins.pathExists secretFile;
  in {
    imports = [
      inputs.agenix.nixosModules.age
    ];

    age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    age.secrets.userPassword = lib.mkIf hasSecret {
      file = secretFile;
      owner = config.preferences.user.name;
      mode = "0400";
    };
  };
}

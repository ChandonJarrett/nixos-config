{...}: {
  flake.nixosModules.devtools = {pkgs, config, lib, ...}: let
    user = config.preferences.user.name;
    fullName = config.preferences.user.fullName;
    email = config.preferences.user.email;
  in {
    programs.git.enable = true;

    hjem.users.${user}.files = {
      ".config/git/config".text = ''
        ${lib.optionalString ("${email}" != "") ''
          [user]
            name = ${fullName}
            email = ${email}
        ''}
        [init]
          defaultBranch = main
        [advice]
          defaultBranchName = false
      '';
    };

    environment.systemPackages = with pkgs; [
      nodejs
      gcc
      rustc
      cargo
      rust-analyzer
      go
      gopls
    ];
  };
}

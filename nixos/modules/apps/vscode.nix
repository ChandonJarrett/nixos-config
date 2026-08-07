{self, ...}: {
  flake.nixosModules.vscode = {
    pkgs,
    config,
    lib,
    ...
  }: let
    user = config.preferences.user.name;

    theme = self.theme;
    palette = theme.palette;

    vscodeSettings = pkgs.replaceVars ./vscode/settings.json {
      inherit
        (palette)
        base00
        base02
        base03
        base05
        base09
        base0A
        base0B
        base0D
        base0E
        ;
    };
  in {
    config = lib.mkIf config.preferences.apps.vscode {
      environment.systemPackages = [
        (pkgs.vscode-with-extensions.override {
          vscode = pkgs.vscode;
          vscodeExtensions = with pkgs.vscode-extensions; [
            bbenoist.nix
            ms-vscode-remote.remote-ssh
            ms-vscode-remote.remote-containers
            ritwickdey.liveserver
            vscode-icons-team.vscode-icons
          ];
        })
      ];

      hjem.users.${user}.files = {
        ".config/Code/User/settings.json".source = vscodeSettings;
      };
    };
  };
}

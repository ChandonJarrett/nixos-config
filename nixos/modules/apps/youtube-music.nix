{
  flake.nixosModules.youtube-music = {pkgs, config, lib, ...}: {
    config = lib.mkIf config.preferences.apps.youtubeMusic {
      environment.systemPackages = [
        pkgs.pear-desktop
      ];
    };
  };
}

{self, lib, ...}: {
  flake.nixosModules.apps = {
    options.preferences.apps = {
      firefox = (lib.mkEnableOption "Firefox") // { default = true; };
      chromium = (lib.mkEnableOption "Chromium") // { default = true; };
      gimp = (lib.mkEnableOption "Gimp") // { default = true; };
      obsidian = (lib.mkEnableOption "Obsidian") // { default = true; };
      vscode = (lib.mkEnableOption "VS Code") // { default = true; };
      youtubeMusic = (lib.mkEnableOption "YouTube Music") // { default = true; };
      virtualization = (lib.mkEnableOption "Virtualization") // { default = false; };
    };

    imports = [
      self.nixosModules.firefox
      self.nixosModules.chromium
      self.nixosModules.gimp
      self.nixosModules.obsidian
      self.nixosModules.vscode
      self.nixosModules.youtube-music
      self.nixosModules.virtualization
    ];
  };
}

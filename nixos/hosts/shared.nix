# Shared host defaults
{...}: {
  flake.nixosModules.hostShared = {pkgs, ...}: {
    boot = {
      supportedFilesystems.ntfs = true;
      kernelPackages = pkgs.linuxPackages_latest;
      kernelModules = [
        "coretemp"
        "cpuid"
      ];
      kernelParams = ["quiet" "splash" "rd.udev.log_level=3"];

      plymouth.enable = true;
    };

    hardware = {
      graphics.enable = true;
      graphics.enable32Bit = true;

      enableAllFirmware = true;

      bluetooth.enable = true;
      bluetooth.powerOnBoot = true;
    };

    zramSwap = {
      enable = true;
      memoryPercent = 50;
      algorithm = "zstd";
    };

    security.polkit.enable = true;

    environment.systemPackages = with pkgs; [
      pciutils
      usbutils

      winetricks
      glib
      android-tools
    ];
  };
}
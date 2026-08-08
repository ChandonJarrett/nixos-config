{...}: {
  flake.nixosModules.hostShared = {
    pkgs,
    config,
    ...
  }: {
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
      # Pulls in redistributable microcode (intel/amd); the generated
      # hardware-configuration.nix files wire updateMicrocode to this.
      enableRedistributableFirmware = true;

      bluetooth.enable = true;
      bluetooth.powerOnBoot = config.preferences.hardware.bluetooth;
    };

    # 12-thread desktop CPUs on both hosts.
    nix.settings.max-jobs = 12;

    zramSwap = {
      enable = true;
      memoryPercent = 50;
      algorithm = "zstd";
    };

    security.polkit.enable = true;

    environment.systemPackages = with pkgs; [
      pciutils
      usbutils
    ];
  };
}

# !!! PLACEHOLDER — DO NOT DEPLOY TO THE 'main' MACHINE AS-IS !!!
#
# This file currently MIRRORS the thinkpad's hardware configuration so the
# flake evaluates and the repo stays committable.
#
# The disk UUIDs, partition layout, kernel modules, and CPU settings below
# all belong to the THINKPAD, not to 'main'. Before running
# `sudo nixos-rebuild switch --flake .#main` on the real 'main' machine,
# regenerate this file there with:
#
#     sudo nixos-generate-config --root /
#
# and paste the output here (the generated file lives at
# /etc/nixos/hardware-configuration.nix on the target machine).
#
# TODO: replace this with real hardware-configuration.nix for 'main'.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Loud reminder on every rebuild until this placeholder is replaced.
  warnings = [
    "PLACEHOLDER hardware-configuration.nix for 'main': the disk UUIDs, kernel modules "
    "and CPU settings below mirror the THINKPAD. Do NOT deploy to the real 'main' "
    "machine — regenerate this file there with: sudo nixos-generate-config --root /"
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7e8e33ba-1d89-4a9d-b4f9-b30615ab01ac";
    fsType = "btrfs";
    options = ["subvol=@"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/7e8e33ba-1d89-4a9d-b4f9-b30615ab01ac";
    fsType = "btrfs";
    options = ["subvol=@home"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/7e8e33ba-1d89-4a9d-b4f9-b30615ab01ac";
    fsType = "btrfs";
    options = ["subvol=@nix"];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/7e8e33ba-1d89-4a9d-b4f9-b30615ab01ac";
    fsType = "btrfs";
    options = ["subvol=@log"];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-uuid/7e8e33ba-1d89-4a9d-b4f9-b30615ab01ac";
    fsType = "btrfs";
    options = ["subvol=@snapshots"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D0A6-14DB";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

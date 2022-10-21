{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  #
  # Kernel
  #

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
  '';

  # Update CPU microcode and use power-saving mode for less noise.
  hardware.cpu.intel.updateMicrocode = true;
  powerManagement.cpuFreqGovernor = "powersave";

  #
  # System disk
  #

  # OS partition.
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9c8fb6a0-122f-4d1f-b3c0-b8d9f62faa5e";
    fsType = "ext4";
  };

  # LUKS full-disk encryption (however, I'd recommend LUKS on LVM).
  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/7fc7dbe1-abc5-416c-854b-e56454979f36";

  # Boot partition.
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/FCCB-528B";
    fsType = "vfat";
  };

  #
  # Swap space
  #

  swapDevices =
    [{ device = "/dev/disk/by-uuid/b507ccfb-03e4-4465-a0f8-cfef83eeb0a7"; }];

  #
  # High-resolution display
  #

  hardware.video.hidpi.enable = lib.mkDefault true;
}

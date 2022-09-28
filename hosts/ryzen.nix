{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  ##
  # KERNEL
  ##

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "wl" ];
  boot.extraModprobeConfig = ''
    options snd_usb_audio vid=0x1235 pid=0x8211 device_setup=1
    options kvm_amd nested=1
  '';

  # Update CPU microcode and use power-saving mode for less noise.
  hardware.cpu.amd.updateMicrocode = true;
  powerManagement.cpuFreqGovernor = "schedutil";

  ##
  # NIXOS
  ##

  #
  # Full-disk encryption (I recommend LUKS on LVM for more flexibility).
  #

  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/ad56d51b-f307-4e31-a2c1-86ae009c003c";

  #
  # Root partition
  #

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7ae6ab05-acdb-4de9-b7ac-b9de77fc43b2";
    fsType = "ext4";
  };

  #
  # Boot partition
  #

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/BA3F-3913";
    fsType = "vfat";
  };

  #
  # Swap
  #

  swapDevices =
    [{ device = "/dev/disk/by-uuid/5920873f-f9a3-4e6c-85a4-6930d43fe32a"; }];

  ##
  # NIX STORE
  ##

  fileSystems."/mnt/nix" = {
    device = "/dev/disk/by-uuid/75f6635a-5471-4e1a-8dc5-4016afac8241";
    fsType = "ext4";
  };

  ##
  # STORAGE
  ##

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/b40734c6-5d76-4adf-8c2f-b816737f3d24";
    fsType = "ext4";
  };
}

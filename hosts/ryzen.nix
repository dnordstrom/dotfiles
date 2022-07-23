{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "wl" ]; # [ "kvm-amd" "wl" ];
  boot.extraModprobeConfig = ''
    options snd_usb_audio vid=0x1235 pid=0x8211 device_setup=1
    # options kvm_amd nested=1
    # options kvm_intel nested=1
    # options kvm_intel emulate_invalid_guest_state=0
    # options kvm ignore_msrs=1
  '';

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7ae6ab05-acdb-4de9-b7ac-b9de77fc43b2";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/ad56d51b-f307-4e31-a2c1-86ae009c003c";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/BA3F-3913";
    fsType = "vfat";
  };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/F850543F505406B2";
    fsType = "ntfs";
  };

  fileSystems."/mnt/storage2" = {
    device = "/dev/disk/by-uuid/01D1B3DE89435D20";
    fsType = "ntfs";
  };

  hardware.cpu.amd.updateMicrocode = true;

  swapDevices =
    [{ device = "/dev/disk/by-uuid/5920873f-f9a3-4e6c-85a4-6930d43fe32a"; }];
}

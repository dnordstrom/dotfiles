{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  ##
  # KERNEL
  ##

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

  # Update CPU microcode and use power-saving mode for less noise.
  hardware.cpu.amd.updateMicrocode = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  ##
  # SYSTEM
  ##

  # Full-disk encryption: I recommend LUKS on LVM for more flexibility.

  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/ad56d51b-f307-4e31-a2c1-86ae009c003c";

  # OS partition

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7ae6ab05-acdb-4de9-b7ac-b9de77fc43b2";
    fsType = "ext4";
  };

  # Boot partition

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/BA3F-3913";
    fsType = "vfat";
  };

  ##
  # STORAGE
  ##

  fileSystems."/mnt/nix" = {
    device = "/dev/disk/by-uuid/45bbf590-b8f0-473f-b86c-5a1343c1efc1";
    fsType = "ext4";
  };

  ##
  # NIX STORE
  ##

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/b1f89618-d029-4d96-9a66-2e871ca8304d";
    fsType = "ext4";
  };

  ##
  # SWAP
  ##

  swapDevices =
    [{ device = "/dev/disk/by-uuid/5920873f-f9a3-4e6c-85a4-6930d43fe32a"; }];
}

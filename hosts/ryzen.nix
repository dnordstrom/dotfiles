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
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.extraModprobeConfig = ''
    options snd_usb_audio vid=0x1235 pid=0x8211 device_setup=1
    options kvm_amd nested=1
  '';

  # Update CPU microcode and use power-saving mode for less noise.
  hardware.cpu.amd.updateMicrocode = true;

  # Set power management options.
  powerManagement = {
    cpuFreqGovernor = "schedutil";
    powertop.enable = true;
  };

  ##
  # STORAGE: NIX-1
  #
  # Filesystem is set up for full-disk encryption by adding a LUKS encryption layer around the usual
  # simple partitioning. Other methods may suit you better: LUKS inside LVM, LVM inside LUKS, etc.
  # 
  # There are pros and cons to consider, but before considering those, you may want to consider ZFS.
  # As a modern filesystem standard with built-in support for encryption, it would appear relevant.
  #
  # During installation, we simply created a cryptroot LUKS mapping to `/dev/mapper/cryptroot`, and
  # use that as the device containing the boot and root partitions. I.e., when booting, passphrase
  # must be entered to unlock that cryptroot, so that the system on it can be launched.
  #
  # See wiki: https://nixos.wiki/wiki/Full_Disk_Encryption
  ##

  #
  # LUKS virtual device for full-disk encryption.
  #
  # Name: /dev/dm-0
  # Path: /dev/disk/by-uuid/ad56d51b-f307-4e31-a2c1-86ae009c003c
  #

  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/ad56d51b-f307-4e31-a2c1-86ae009c003c";

  #
  # Root partition.
  #
  # Disk size: 250 GiB
  # Disk make: Intel SSD (SSDSCKKF25)
  # Disk name: /dev/sda
  # Disk path: /dev/disk/by-uuid/7ae6ab05-acdb-4de9-b7ac-b9de77fc43b2
  # Partition: /dev/sda1
  #

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7ae6ab05-acdb-4de9-b7ac-b9de77fc43b2";
    fsType = "ext4";
  };

  #
  # Boot partition.
  #
  # Disk size: 250 GiB
  # Disk make: Intel SSD (SSDSCKKF25)
  # Disk name: /dev/sda
  # Disk path: /dev/disk/by-uuid/BA3F-3913
  # Partition: /dev/sda3
  #

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/BA3F-3913";
    fsType = "vfat";
  };

  #
  # Swap partition.
  #
  # Once upgraded to 32GiB RAM, I'll probably just remove this partition. Hopefully soon, since my
  # current memory sticks bottleneck the CPU quite a bit without XMPP overclocking profile.
  #
  # Disk size: 250 GiB
  # Disk make: Intel SSD (SSDSCKKF25)
  # Disk name: /dev/sda
  # Disk path: /dev/disk/by-uuid/5920873f-f9a3-4e6c-85a4-6930d43fe32a
  # Partition: /dev/sda2
  #

  swapDevices =
    [{ device = "/dev/disk/by-uuid/5920873f-f9a3-4e6c-85a4-6930d43fe32a"; }];

  ##
  # STORAGE: NIX-2
  #
  # Separate disk for less I/O and other resource strain when building.
  #
  # Disk size: 120 GiB
  # Disk make: Intel SSD (SSDSC2KW25)
  # Disk name: /dev/sdb
  # Disk path: /dev/disk/by-uuid/75f6635a-5471-4e1a-8dc5-4016afac8241
  # Partition: /dev/sdb1
  ##

  fileSystems."/mnt/nix-2" = {
    device = "/dev/disk/by-uuid/75f6635a-5471-4e1a-8dc5-4016afac8241";
    fsType = "ext4";
  };

  ##
  # STORAGE: STORAGE-1
  # 
  # Disk size: 250 GiB
  # Disk make: Samsung SSD 840
  # Disk path: /dev/disk/by-uuid/690df4aa-ce76-4eb3-ae18-32aa2416242b
  # Disk name: /mnt/storage1
  # Partition: /dev/sdb1
  #

  fileSystems."/mnt/storage-1" = {
    device = "/dev/disk/by-uuid/690df4aa-ce76-4eb3-ae18-32aa2416242b";
    fsType = "ext4";
  };

  ##
  # STORAGE: STORAGE-2
  #
  # Disk size: 250 GiB
  # Disk make: Toshiba TR150
  # Disk path: /dev/disk/by-uuid/b40734c6-5d76-4adf-8c2f-b816737f3d24
  # Disk name: /mnt/storage1
  # Partition: /dev/sdb1
  ##

  fileSystems."/mnt/storage-2" = {
    device = "/dev/disk/by-uuid/b40734c6-5d76-4adf-8c2f-b816737f3d24";
    fsType = "ext4";
  };
}

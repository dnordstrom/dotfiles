{ config, pkgs, ... }:

{
  imports = [ "/etc/nixos/hardware-configuration.nix" ];

  nix.package = pkgs.nixUnstable;
  nix.extraOptions =  ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes ca-derivations ca-references
  '';

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nordixlap";
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  networking.useDHCP = false;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.libinput.enable = true;
  
  services.xserver = {
    layout = "us,se";
    xkbOptions = "caps:escape,grp:shifts_toggle";
  };

  services.xserver.displayManager.sessionPackages = [
   (pkgs.plasma-workspace.overrideAttrs 
     (old: { passthru.providedSessions = [ "plasmawayland" ]; }))
  ];
  
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dnordstrom = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    qutebrowser
    kate
    # latest.firefox-nightly-bin
  ];
}


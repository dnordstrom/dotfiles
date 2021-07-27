{ config, pkgs, stdenv, lib, ... }:

{
  imports = [ ./dell-xps.nix ];

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
  networking.extraHosts = ''
    ***REMOVED***
    ***REMOVED***
    ***REMOVED***
    ***REMOVED***
  '';

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
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

  users.users.dnordstrom = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  environment.systemPackages =
  let
    convox = pkgs.callPackage ./convox.nix {};
  in
  [
    pkgs.git
    pkgs.wget
    pkgs.nodejs
    pkgs.yarn
    pkgs.firefox-beta-bin
    # pkgs.vscode-with-extensions
    pkgs.steam-run
    pkgs.tor-browser-bundle-bin
    convox
  ];
}


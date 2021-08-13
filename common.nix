{ config, pkgs, stdenv, lib, nodePackages, ... }:

{
  nix.package = pkgs.nixUnstable;
  nix.extraOptions =  ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes ca-derivations ca-references
  '';

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "broadcom-sta"
    "firefox-devedition-bin"
    "firefox-devedition-bin-unwrapped"
    "slack"
    "steam-runtime"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nordix";
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  networking.extraHosts = ''
    ***REMOVED***
    ***REMOVED***
    ***REMOVED***
    ***REMOVED***
  '';

  time.timeZone = "Europe/Amsterdam";

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.libinput.enable = true;
  
  services.xserver = {
    layout = "us,se";
    xkbOptions = "caps:escape,grp:shifts_toggle";
  };

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ]; # More codecs, e.g. APTX
    package = pkgs.pulseaudioFull;
  };

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true;

  users.users.dnordstrom = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  security.sudo.extraRules = [{
    users = [ "dnordstrom" ];
    commands = [
      {
        command = "/run/current-system/sw/bin/chown";
        options = [ "SETENV" "NOPASSWD" ];
      }
      {
        command = "/run/current-system/sw/bin/chmod";
        options = [ "SETENV" "NOPASSWD" ];
      }
      {
        command = "/run/current-system/sw/bin/nvim";
        options = [ "SETENV" "NOPASSWD" ];
      }
      {
        command = "/run/current-system/sw/bin/vim";
        options = [ "SETENV" "NOPASSWD" ];
      }
      {
        command = "/run/current-system/sw/bin/nixos-rebuild";
        options = [ "SETENV" "NOPASSWD" ];
      }
    ];
  }];

  environment.systemPackages = with pkgs; [
    git
    wget
    nodejs
    yarn
    steam-run
  ];
}


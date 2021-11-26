{ config, pkgs, stdenv, lib, nodePackages, ... }:

let
  udev-rules = pkgs.callPackage ./packages/udev-rules.nix {};
in
{
  #
  # General
  #

  time.timeZone = "Europe/Amsterdam";

  #
  # Nixpkgs
  #

  nix.package = pkgs.nixUnstable;
  nix.extraOptions =  ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes ca-derivations ca-references
  '';

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "broadcom-sta"
    "corefonts"
    "input-fonts"
    "slack"
    "steam-runtime"
    "spotify"
    "spotify-unwrapped"
  ];

  nixpkgs.config.input-fonts.acceptLicense = true;
  nixpkgs.config.firefox.enableTridactylNative = true;

  #
  # Booting
  #

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #
  # Networking
  #

  networking.hostName = "nordix";
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  networking.extraHosts = ''
    ***REMOVED***
    ***REMOVED***
    ***REMOVED***
    ***REMOVED***
    ***REMOVED***

    ***REMOVED***
    ***REMOVED***
    ***REMOVED***
    ***REMOVED***
    ***REMOVED***
  '';

  #
  # Fonts
  #

  fonts.fonts = with pkgs; [
    cascadia-code
    noto-fonts
    noto-fonts-emoji
    fira-code
    fira-code-symbols

    (nerdfonts.override {
      fonts = [
        "Iosevka"
        "FiraCode"
        "CascadiaCode"
        "Hack"
      ];
    })
  ];

  #
  # Services
  #

  services.xserver = {
    enable = true;

    displayManager = {
      sddm = {
        enable = true;
        settings.Wayland.SessionDir = "${pkgs.sway}/share/wayland-sessions"; # Enable Sway
      };
    };

    # For their utilities
    desktopManager = {
      gnome.enable = true;
      plasma5.enable = true;
    };

    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
      	clickMethod = "clickfinger";
      };
    };

    layout = "us,se";
    xkbOptions = "caps:escape_shifted_capslock,grp:shifts_toggle,terminate:ctrl_alt_bksp,lv3:ralt_switch_multikey";
    xkbVariant = ",us";
  };

  services.gnome.chrome-gnome-shell.enable = true;
  services.blueman.enable = true;
  services.udev.packages = [ udev-rules ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #
  # Security
  #

  security.sudo.wheelNeedsPassword = false;
  security.rtkit.enable = true; # For Pipewire (recommended in Nix wiki)

  # Make swaylock accept correct password
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  #
  # Hardware
  #

  hardware = {
    pulseaudio.enable = false;

    opengl = {
      enable = true;
      driSupport = true;
    };

    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };

  #
  # XDG
  #

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
      wlr = {
        enable = true;
      };
    };
  };

  #
  # Users
  #

  users.users.dnordstrom = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input" # For ydotool udev rule
    ];
    shell = pkgs.zsh;
  };

  #
  # System-wide packages
  #

  environment.systemPackages = with pkgs; [
    git
    wget
    nodejs
    yarn
    steam-run
  ];
}


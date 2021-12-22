{ config, pkgs, stdenv, lib, ... }:

{
  #
  # IMPORTS
  #

  imports = [ ../cachix.nix ];

  #
  # GENERAL
  #

  time.timeZone = "Europe/Stockholm";

  nix.package = pkgs.nixUnstable;
  nix.trustedUsers = [ "root" "dnordstrom" ];

  #
  # Optimization
  #

  # Automatically symlink files with identical contents
  nix.autoOptimiseStore = true;

  # Automatically remove unused packages
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  #
  # Package configuration
  #

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "broadcom-sta"
      "corefonts"
      "input-fonts"
      "slack"
      "steam-runtime"
      "spotify"
      "spotify-unwrapped"
    ];

  # TODO: Keep an eye on this outdated crap
  nixpkgs.config.permittedInsecurePackages = [ "electron-9.4.4" ];
  nixpkgs.config.input-fonts.acceptLicense = true;
  nixpkgs.config.firefox.enableTridactylNative = true;

  #
  # BOOTING
  #

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #
  # NETWORKING
  #

  networking.hostName = "nordix";
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  networking.nameservers = [ "1.1.1.1" ];

  #
  # FONTS
  #

  fonts.fonts = with pkgs; [
    cascadia-code
    noto-fonts
    noto-fonts-emoji
    fira-code
    fira-code-symbols

    (nerdfonts.override {
      fonts = [ "Iosevka" "FiraCode" "CascadiaCode" "Hack" ];
    })
  ];

  #
  # SERVICES
  #

  services.xserver = {
    enable = true;

    # SDDM with Sway sessions
    displayManager = {
      sddm = {
        enable = true;
        settings.Wayland.SessionDir = "${pkgs.sway}/share/wayland-sessions";
      };
    };

    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        clickMethod = "clickfinger";
      };
    };

    layout = "us,se";
    xkbOptions =
      "caps:escape_shifted_capslock,grp:shifts_toggle,terminate:ctrl_alt_bksp,lv3:ralt_switch_multikey";
    xkbVariant = ",us";
  };

  services.blueman.enable = true;
  services.udev.packages = [ pkgs.udev-rules ];
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.flatpak.enable = true;

  #
  # SECURITY
  #

  security.sudo.wheelNeedsPassword = false;

  # For Pipewire (recommended in Nix wiki)
  security.rtkit.enable = true;

  # Make swaylock accept correct password
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  #
  # HARDWARE
  #

  hardware = {
    pulseaudio.enable = false;

    opengl = {
      enable = true;
      driSupport = true;
    };

    bluetooth = {
      enable = true;
      settings = { General = { Enable = "Source,Sink,Media,Socket"; }; };
    };
  };

  #
  # XDG
  #

  xdg = {
    menus.enable = true;
    icons.enable = true;
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
        xdg-desktop-portal-kde
      ];
      gtkUsePortal = true;
      wlr = {
        enable = true;
        settings = {
          screencast = {
            max_fps = 30;
            output_name = "DP-1";
            chooser_type = "simple";
            chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
          };
        };
      };
    };
  };

  #
  # PROGRAMS
  #

  programs.dconf.enable = true;

  programs.ssh.askPassword =
    pkgs.lib.mkForce "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";

  #
  # USERS
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
  # SYSTEM ENVIRONMENT
  #

  environment.etc.hosts.mode = "0644";

  environment.systemPackages = with pkgs; [
    git
    wget
    nodejs
    yarn
    steam-run # Runs binaries compiled for other distributions
    xdg-desktop-portal
  ];
}


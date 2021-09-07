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
    "corefonts"
    "input-fonts"
    "slack"
    "steam-runtime"
  ];

  nixpkgs.config.input-fonts.acceptLicense = true;

  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
  nixpkgs.config.firefox.enableGnomeExtensions = true;
  nixpkgs.config.firefox.enableTridactylNative = true;

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
    ***REMOVED***
  '';

  time.timeZone = "Europe/Amsterdam";

  services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.libinput.enable = true;

  #  services.xserver.displayManager.sddm = {
  #    enable = false;
  #    settings.Wayland.SessionDir = "${pkgs.libsForQt5.plasma-workspace}/share/wayland-sessions";
  #  };

  services.greetd = {
    enable = true;
    restart = true;
    settings = {
      default_session = {
        # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --time --asterisks --cmd XDG_SESSION_TYPE=wayland dbus-run-session startplasma-wayland";
      };
    };
  };

  services.xserver = {
    layout = "us,se";
    xkbOptions = "caps:escape,grp:shifts_toggle";
  };

  services.gnome.chrome-gnome-shell.enable = true;

  services.blueman.enable = true;

  fonts.fonts = with pkgs; [
    cascadia-code
    noto-fonts
    noto-fonts-emoji
    fira-code
    fira-code-symbols

    # Nerd Fonts to install. Available fonts:
    # https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts
    (nerdfonts.override {
      fonts = [
        "Iosevka"
        "FiraCode"
        "CascadiaCode"
        "Hack"
      ];
    })
  ];

  sound.enable = true;

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };

    pulseaudio = {
      enable = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ]; # More codecs, e.g. APTX
      package = pkgs.pulseaudioFull;
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

  users.users.dnordstrom = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    git
    greetd.tuigreet
    wget
    nodejs
    yarn
    steam-run
  ];
}


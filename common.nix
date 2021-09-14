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

  services.xserver = {
    enable = true;

    displayManager = {
      sddm = {
        enable = true;

        # To enable Sway in SDDM:
        settings.Wayland.SessionDir = "${pkgs.sway}/share/wayland-sessions";
      };
    };

    desktopManager = {
      gnome.enable = true;
      plasma5.enable = true;
    };

    libinput.enable = true;

    layout = "us,se";
    xkbOptions = "caps:escape_shifted_capslock,grp:shifts_toggle,terminate:ctrl_alt_bksp,lv3:ralt_switch_multikey";
    xkbVariant = ",us";
  };

  # Make `swaylock` accept correct password
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
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

  # Recommended in wiki, for Pipewire
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };

    # Using Pipewire instead
    pulseaudio = {
      enable = false;
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
    wget
    nodejs
    yarn
    steam-run
  ];
}


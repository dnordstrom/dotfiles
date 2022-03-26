{ config, pkgs, nordpkgs, stdenv, lib, ... }:

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
  nix.settings.trusted-users = [ "root" "dnordstrom" ];

  #
  # Optimization
  #

  # Automatically symlink files with identical contents
  nix.settings.auto-optimise-store = true;

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
  networking.extraHosts = builtins.readFile ../secrets/hosts;

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

  services.udev.packages = [ pkgs.nordpkgs.udev-rules ];

  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    config.pipewire = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 32;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 32;
        "core.daemon" = true;
      };

      "context.modules" = [
        {
          name = "libpipewire-module-rtkit";
          args = {
            "nice.level" = -15;
            "rt.prio" = 88;
            "rt.time.soft" = 200000;
            "rt.time.hard" = 200000;
          };
          flags = [ "ifexists" "nofail" ];
        }
        { name = "libpipewire-module-protocol-native"; }
        { name = "libpipewire-module-client-node"; }
        { name = "libpipewire-module-adapter"; }
        { name = "libpipewire-module-metadata"; }
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            "pulse.min.req" = "32/48000";
            "pulse.default.req" = "32/192000";
            "pulse.max.req" = "32/48000";
            "pulse.min.quantum" = "32/192000";
            "pulse.max.quantum" = "32/192000";
            "server.address" = [ "unix:native" ];
          };
        }
      ];

      "stream.properties" = {
        "node.latency" = "32/192000";
        "resample.quality" = 1;
      };
    };
    media-session.config.alsa-monitor = {
      rules = [{
        matches = [{ "node.name" = "alsa_output.*"; }];
        actions = {
          update-props = {
            "audio.format" = "S32LE";
            "audio.rate" =
              384000; # For USB soundcards, it should be twice the desired rate
            "api.alsa.period-size" =
              32; # Defaults to 1024, tweak by trial-and-error
          };
        };
      }];
    };
  };

  services.flatpak.enable = true;

  services.yubikey-agent.enable = true;

  services.gnome.gnome-keyring.enable = true;

  #
  # SECURITY
  #

  # Yubikey authentication, reads tokens from `~/.yubico/authorized_yubikeys`
  security.pam.yubico = {
    mode = "client";
    id = "70449";
    enable = true;
    control = "sufficient";
  };

  # Don't require `sudo` password for admin group users
  security.sudo.wheelNeedsPassword = false;

  # For Pipewire (recommended in Nix wiki)
  security.rtkit.enable = true;

  # Privilege escalation
  security.polkit.enable = true;

  # Make swaylock accept correct password.
  # See: https://github.com/mortie/swaylock-effects/blob/master/pam/swaylock
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
    polkit_gnome
    git
    wget
    nodejs
    yarn
    steam-run # Runs binaries compiled for other distributions
    xdg-desktop-portal
  ];
}

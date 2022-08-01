{ config, pkgs, stdenv, lib, ... }:

{
  #
  # IMPORTS
  #

  imports = [ ../cachix.nix ];

  #
  # GENERAL
  #

  # Configuration version
  system.stateVersion = "22.11";

  # Set correct time-zone
  time.timeZone = "Europe/Stockholm";

  nix = {
    # Use unstable `nix`
    package = pkgs.nixUnstable;

    # CPU scheduling policy for nix daemon: "other" for regular (default), "batch" for
    # non-interactive, "idle" for low priority. Let's try that. Don't care if it takes longer as
    # long as the PC isn't completely unresponsive during builds.
    daemonCPUSchedPolicy = "idle";

    # Build settings
    settings = {
      # You only get half of our cores
      cores = 4;

      # Users with elevated `nix` command privileges
      trusted-users = [ "root" "dnordstrom" ];

      # Automatically symlink identical files
      auto-optimise-store = true;
    };

    # Automatically have nix daemon symlink identical files weekly to free storage space
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    # Automatically have nix daemon remove unused packages after 30 days
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Disable annoying warning about dirty Git tree
    extraOptions = ''
      warn-dirty = false
    '';
  };

  #
  # Package configuration
  #

  nixpkgs.config = {
    allowUnsupportedSystem = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "corefonts"
        "datagrip"
        "input-fonts"
        "slack"
      ];
    input-fonts.acceptLicense = true;
    firefox.enableTridactylNative = true;
  };

  #
  # BOOTING
  #

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;

      grub = {
        backgroundColor = "#D9DCD3";
        configurationLimit = 100;
        device = "nodev";
        efiSupport = true;
        enable = false;
        useOSProber = false;
        version = 2;
      };

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };

  #
  # NETWORKING
  #

  networking = {
    hostName = "nordix";
    wireless.enable = false;
    networkmanager.enable = true;
    useDHCP = false;
  };

  #
  # FONTS
  #

  fonts = {
    fonts = with pkgs;
      [ (nerdfonts.override { fonts = [ "Iosevka" "Hack" ]; }) ];
  };

  #
  # SERVICES
  #

  services = {
    interception-tools = {
      enable = true;
      plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
      udevmonConfig = ''
        - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /etc/nixos/config/intercept/keyboard.yaml | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
      '';
    };

    pcscd = {
      enable = true;
      plugins = [ pkgs.ccid ];
    };

    openssh.enable = true;

    blueman.enable = true;

    udev.packages = [ pkgs.nordpkgs.udev-rules ];

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;

      config.pipewire = {
        context.properties = {
          link.max-buffers = 16;
          default.clock.rate = 44100;
          default.clock.allowed-rates =
            [ 44100 48000 88200 96000 176400 192000 384000 ];
          core.daemon = true;
          core.name = "pipewire-0";
        };
      };

      media-session.config.alsa-monitor.rules = [
        # USB digital output
        {
          matches = [{
            node.name =
              "alsa_output.usb-Focusrite_Scarlett_Solo_USB_Y7WND901607934-00.iec958-stereo";
          }];
          actions = {
            update-props = {
              asdio.allowed-rates = [ 44100 48000 88200 96000 176400 192000 ];
              audio.format = "S32_LE";
              audio.rate = 44100;
              resample.quality = 10;
            };
          };
        }
        # USB digital input
        {
          matches = [{
            node.name =
              "alsa_input.usb-Focusrite_Scarlett_Solo_USB_Y7WND901607934-00.iec958-stereo";
          }];
          actions = {
            update-props = {
              audio.allowed-rates = [ 44100 48000 88200 96000 176400 192000 ];
              audio.format = "S16_LE";
              audio.rate = 44100;
            };
          };
        }
        # Onboard analog output
        {
          matches =
            [{ node.name = "alsa_output.pci-0000_0b_00.3.analog-stereo"; }];
          actions = {
            update-props = {
              audio.allowed-rates = [ 44100 48000 ];
              audio.format = "S24_LE";
              audio.rate = 44100;
              resample.quality = 10;
            };
          };
        }
        # Onboard digital output
        {
          matches =
            [{ node.name = "alsa_output.pci-0000_0b_00.3.iec958-stereo"; }];
          actions = {
            update-props = {
              audio.allowed-rates = [ 44100 48000 88200 96000 176400 192000 ];
              audio.format = "S32_LE";
              audio.rate = 44100;
              resample.quality = 10;
            };
          };
        }
        # Onboard analog input
        {
          matches =
            [{ node.name = "alsa_input.pci-0000_0b_00.3.analog-stereo"; }];
          actions = {
            update-props = {
              audio.allowed-rates = [ 44100 ];
              audio.format = "S16_LE";
              audio.rate = 44100;
            };
          };
        }
      ];

      # Bluetooth audio
      media-session.config.bluez-monitor.rules = [
        {
          matches = [{ device.name = "~bluez_card.*"; }];
          actions = {
            update-props = {
              bluez5.reconnect-profiles = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
              bluez5.msbc-support = true;
              bluez5.sbc-xq-support = true;
            };
          };
        }
        {
          matches = [
            { node.name = "~bluez_input.*"; }
            { node.name = "~bluez_output.*"; }
          ];
          actions = { node.pause-on-idle = false; };
        }
      ];
    };

    # Roon Server will get installed automatically as a systemd service
    roon-server = {
      enable = true;
      openFirewall = true;
    };

    dbus = {
      enable = true;
      packages = with pkgs; [ openvpn3 protonvpn-cli protonvpn-gui ];
    };

    flatpak.enable = true;

    yubikey-agent.enable = true;
  };

  #
  # Systemd
  #

  systemd = {
    services = {
      systemd-udev-settle.enable = false;
      NetworkManager-wait-online.enable = false;
    };
  };

  #
  # SECURITY
  #

  security = {
    # Yubikey authentication, reads tokens from `~/.yubico/authorized_yubikeys`
    pam.yubico = {
      mode = "client";
      id = "70449";
      enable = true;
      control = "sufficient";
    };

    # Disable `sudo`
    sudo.enable = false;

    # Enable `doas`
    doas = {
      enable = true;
      wheelNeedsPassword = false;
    };

    # For Pipewire (recommended in Nix wiki)
    rtkit.enable = true;

    # Privilege escalation
    polkit.enable = true;

    # Make swaylock accept correct password.
    # See: https://github.com/mortie/swaylock-effects/blob/master/pam/swaylock
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };

  #
  # SECRETS
  #

  age = {
    identityPaths = [ /home/dnordstrom/.ssh/id_ed25519 ];
    secrets = {
      env = {
        file = ../secrets/env.age;
        path = "/home/dnordstrom/.env";
        owner = "dnordstrom";
        group = "users";
      };
    };
  };

  #
  # HARDWARE
  #

  sound.enable = false;

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
        xdg-desktop-portal-gnome
      ];

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

  programs = {
    dconf.enable = true;

    ssh.askPassword =
      pkgs.lib.mkForce "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
  };

  #
  # USERS
  #   
  #   `isNormalUser = true;` creates a home directory while `isSystemUser = true;` doesn't. For
  #   appropriate access, users need to be in the right groups, such as "input" for libinput, or
  #   "audio" for the Roon Server user.
  #
  #   Remember to add any groups not created by Nix modules, like "openvpn" below.
  #

  users = {
    users = {
      dnordstrom = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "audio"
          "input"
          "kvm"
          "libvirtd"
          "qemu-libvirtd"
          "vboxusers"
        ];
        shell = pkgs.zsh;
      };

      openvpn = {
        isSystemUser = true;
        description = "OpenVPN 3 user";
        group = "openvpn";
      };
    };

    groups.openvpn = { };
  };

  #
  # SYSTEM ENVIRONMENT
  #

  # Global Qt styling, automatically installs necessary packages depending on settings, e.g.
  # we use `qt5ct` which installs `pkgs.libsForQt5.qt5ct`, a standalone configuration GUI.
  qt5 = {
    enable = true;

    # QT_QPA_PLATFORMTHEME
    #   The platform theme specifies the icons, fonts, widget style, and more.
    #
    #   "gnome" -> If you use Gnome       -> Uses as many Gnome settings as possible to style
    #   "kde"   -> If you use KDE         -> Uses KDE's Qt settings to style
    #   "lxqt"  -> If you use LXDE        -> Uses LXDE's Qt settings to style
    #   "gtk2"  -> If you use mostly GTK  -> Uses GTK theme to style
    #   "qt5ct" -> If you use a computer  -> Uses `qt5ct` app to specify styles, icons, and cursors

    platformTheme = "qt5ct";

    # QT_STYLE_OVERRIDE
    #    Optionally overrides widget style. We skip this since we use `qt5ct` which sets it for us.
    #
    #   "adwaita"
    #   "adwaita-dark"
    #   "cleanlooks"
    #   "gtk2"
    #   "motif"
    #   "plastique"
    #
    # style = "gtk2";
  };

  environment = {
    variables = {
      VST_PATH =
        "/nix/var/nix/profiles/system/lib/vst:/var/run/current-system/sw/lib/vst:~/.vst";
      LXVST_PATH =
        "/nix/var/nix/profiles/system/lib/lxvst:/var/run/current-system/sw/lib/lxvst:~/.lxvst";
      LADSPA_PATH =
        "/nix/var/nix/profiles/system/lib/ladspa:/var/run/current-system/sw/lib/ladspa:~/.ladspa";
      LV2_PATH =
        "/nix/var/nix/profiles/system/lib/lv2:/var/run/current-system/sw/lib/lv2:~/.lv2";
      DSSI_PATH =
        "/nix/var/nix/profiles/system/lib/dssi:/var/run/current-system/sw/lib/dssi:~/.dssi";
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };

    systemPackages = with pkgs; [
      git
      nodejs
      ntfs3g
      polkit_gnome
      roon-server
      steam-run
      wget
      xdg-desktop-portal
      yarn
    ];

    pathsToLink = [ "/share/zsh" "/libexec" ];

    # Launch Sway if logging in via tty1 and River if via tty2.
    loginShellInit = ''
      [ "$(tty)" = "/dev/tty1" ] && exec /home/dnordstrom/.config/sway/start
      [ "$(tty)" = "/dev/tty2" ] && exec /home/dnordstrom/.config/river/start
    '';
  };
}

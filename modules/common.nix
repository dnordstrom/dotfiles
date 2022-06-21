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

    # Users with elevated `nix` command privileges
    settings = {
      trusted-users = [ "root" "dnordstrom" ];

      # Max concurrent derivation builds
      max-jobs = 2;

      # Max cores per derivation build
      cores = 3;

      # Automatically symlink identical files
      auto-optimise-store = true;
    };

    # Automatically remove unused packages
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Disable annoying warning about dirty Git tree
    extraOptions = "warn-dirty = false";
  };

  #
  # Package configuration
  #

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "corefonts"
      "datagrip"
      "input-fonts"
      "slack"
      "steam-runtime"
      "spotify"
      "spotify-unwrapped"
      "hqplayer-desktop"
    ];

  nixpkgs.config = {
    permittedInsecurePackages = [ "electron-9.4.4" "electron-12.2.3" ];
    input-fonts.acceptLicense = true;
    firefox.enableTridactylNative = true;
  };

  #
  # BOOTING
  #

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = false;

      grub = {
        backgroundColor = "#D9DCD3";
        configurationLimit = 50;
        device = "nodev";
        efiSupport = true;
        enable = true;
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
    fonts = with pkgs; [
      cascadia-code
      noto-fonts
      noto-fonts-emoji
      fira-code
      fira-code-symbols

      (nerdfonts.override {
        fonts = [ "Iosevka" "FiraCode" "CascadiaCode" "Hack" ];
      })
    ];
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
      jack.enable = true;
      wireplumber.enable = true;

      config.pipewire = {
        "context.properties" = {
          "link.max-buffers" = 16;
          "default.clock.rate" = 44100;
          "default.clock.allowed-rates" =
            [ 44100 48000 88200 96000 176400 192000 384000 ];
          "core.daemon" = true;
          "core.name" = "pipewire-0";
        };

        "context.spa-libs" = {
          "audio.convert.*" = "audioconvert/libspa-audioconvert";
          "support.*" = "support/libspa-support";
          "api.v4l2.*" = "v4l2/libspa-v4l2";
          "api.libcamera.*" = "libcamera/libspa-libcamera";
          "api.bluez5.*" = "bluez5/libspa-bluez5";
          "api.vulkan.*" = "vulkan/libspa-vulkan";
        };

        "context.modules" = [
          { name = "libpipewire-module-protocol-native"; }
          { name = "libpipewire-module-profiler"; }
          { name = "libpipewire-module-metadata"; }
          { name = "libpipewire-module-spa-device-factory"; }
          { name = "libpipewire-module-spa-node-factory"; }
          { name = "libpipewire-module-client-node"; }
          { name = "libpipewire-module-client-device"; }
          {
            name = "libpipewire-module-portal";
            flags = [ "ifexists" "nofail" ];
          }
          {
            name = "libpipewire-module-access";
            args = { };
          }
          { name = "libpipewire-module-adapter"; }
          { name = "libpipewire-module-link-factory"; }
          { name = "libpipewire-module-session-manager"; }
        ];
      };

      config.pipewire-pulse = {
        "stream.properties" = { "resample.quality" = 10; };
      };

      config.client = { "stream.properties" = { "resample.quality" = 10; }; };

      media-session.config.alsa-monitor.rules = [
        # USB digital output
        {
          matches = [{
            "node.name" =
              "alsa_output.usb-Focusrite_Scarlett_Solo_USB_Y7WND901607934-00.iec958-stereo";
          }];
          actions = {
            update-props = {
              "audio.allowed-rates" = [ 44100 48000 88200 96000 176400 192000 ];
              "audio.format" = "S32_LE";
              "audio.rate" = 44100;
              "resample.quality" = 10;
            };
          };
        }
        # USB digital input
        {
          matches = [{
            "node.name" =
              "alsa_input.usb-Focusrite_Scarlett_Solo_USB_Y7WND901607934-00.iec958-stereo";
          }];
          actions = {
            update-props = {
              "audio.allowed-rates" = [ 44100 48000 88200 96000 176400 192000 ];
              "audio.format" = "S16_LE";
              "audio.rate" = 44100;
            };
          };
        }
        # Onboard analog output
        {
          matches =
            [{ "node.name" = "alsa_output.pci-0000_0b_00.3.analog-stereo"; }];
          actions = {
            update-props = {
              "audio.allowed-rates" = [ 44100 48000 ];
              "audio.format" = "S24_LE";
              "audio.rate" = 44100;
              "resample.quality" = 10;
            };
          };
        }
        # Onboard digital output
        {
          matches =
            [{ "node.name" = "alsa_output.pci-0000_0b_00.3.iec958-stereo"; }];
          actions = {
            update-props = {
              "audio.allowed-rates" = [ 44100 48000 88200 96000 176400 192000 ];
              "audio.format" = "S32_LE";
              "audio.rate" = 44100;
              "resample.quality" = 10;
            };
          };
        }
        # Onboard analog input
        {
          matches =
            [{ "node.name" = "alsa_input.pci-0000_0b_00.3.analog-stereo"; }];
          actions = {
            update-props = {
              "audio.allowed-rates" = [ 44100 ];
              "audio.format" = "S16_LE";
              "audio.rate" = 44100;
            };
          };
        }
      ];

      # Bluetooth audio
      media-session.config.bluez-monitor.rules = [
        {
          matches = [{ "device.name" = "~bluez_card.*"; }];
          actions = {
            "update-props" = {
              "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
              "bluez5.msbc-support" = true;
              "bluez5.sbc-xq-support" = true;
            };
          };
        }
        {
          matches = [
            { "node.name" = "~bluez_input.*"; }
            { "node.name" = "~bluez_output.*"; }
          ];
          actions = { "node.pause-on-idle" = false; };
        }
      ];
    };

    roon-server = {
      enable = true;
      openFirewall = true;
    };

    dbus = {
      enable = true;
      packages = [ pkgs.nordpkgs.openvpn3 ];
    };

    flatpak.enable = true;

    yubikey-agent.enable = true;

    gnome.gnome-keyring.enable = true;
  };

  #
  # Systemd
  #

  systemd = {
    services.systemd-udev-settle.enable = false;
    services.NetworkManager-wait-online.enable = false;
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
  # Virtualization
  #

  virtualisation = {
    docker.enable = true;
    virtualbox.host.enable = true;

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull ];
        };
        swtpm.enable = true;
      };
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
        xdg-desktop-portal
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
        xdg-desktop-portal-kde
        xdg-desktop-portal-gnome
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

  programs = {
    qt5ct.enable = true;

    dconf.enable = true;

    ssh.askPassword =
      pkgs.lib.mkForce "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
  };

  #
  # USERS
  #

  users = {
    users = {
      dnordstrom = {
        isNormalUser = true;
        extraGroups = [
          "audio"
          "input"
          "kvm"
          "libvirtd"
          "qemu-libvirtd"
          "vboxusers"
          "wheel"
        ];
        shell = pkgs.zsh;

      };

      openvpn = {
        isSystemUser = true;
        group = "openvpn";
      };
    };

    groups.openvpn = { };
  };

  #
  # SYSTEM ENVIRONMENT
  #

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
      nordpkgs.openvpn3
      ntfs3g
      polkit_gnome
      refind
      roon-server
      steam-run
      virt-manager
      virt-manager-qt
      virt-viewer
      wget
      win-qemu
      win-virtio
      xdg-desktop-portal
      yarn
    ];

    pathsToLink = [ "/share/zsh" "/libexec" ];

    loginShellInit = ''
      [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ] && exec sway
    '';
  };
}

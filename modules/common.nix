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
  nix.settings.trusted-users = [ "root" "dnordstrom" ];

  #
  # Optimization
  #

  # Automatically symlink identical files
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
      "corefonts"
      "datagrip"
      "input-fonts"
      "slack"
      "steam-runtime"
      "spotify"
      "spotify-unwrapped"
      "hqplayer-desktop"
    ];

  # TODO: Keep an eye on this outdated crap
  nixpkgs.config.permittedInsecurePackages = [ "electron-9.4.4" ];
  nixpkgs.config.input-fonts.acceptLicense = true;
  nixpkgs.config.firefox.enableTridactylNative = true;

  #
  # BOOTING
  #

  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.configurationLimit = 50;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #
  # NETWORKING
  #

  networking.hostName = "nordix";
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  networking.useDHCP = false;

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

  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.caps2esc ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc 0.1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };

  services.blueman.enable = true;

  services.udev.packages = [ pkgs.nordpkgs.udev-rules ];

  services.pipewire = {
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
        {
          name = "libpipewire-module-session-manager";
        }
        # {
        #   "name" = "libpipewire-module-filter-chain";
        #   "args" = {
        #     "node.name" = "rnnoise_source";
        #     "node.description" = "Noise Canceling Source";
        #     "media.name" = "Noise Canceling Source";
        #     "filter.graph" = {
        #       nodes = [{
        #         type = "ladspa";
        #         name = "rnnoise";
        #         plugin =
        #           "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
        #         label = "noise_suppressor_stereo";
        #         channels = 2;
        #         control = { "VAD Threshold (%)" = 95.0; };
        #       }];
        #     };
        #     "capture.props" = { "node.passive" = true; };
        #     "playback.props" = { "media.class" = "Audio/Source"; };
        #   };
        # }
      ];

      "context.objects" = [
        {
          # A default dummy driver. This handles nodes marked with the "node.always-driver"
          # properyty when no other driver is currently active. JACK clients need this.
          factory = "spa-node-factory";
          args = {
            "factory.name" = "support.node.driver";
            "node.name" = "Dummy-Driver";
            "priority.driver" = 8000;
          };
        }
        {
          factory = "adapter";
          args = {
            "factory.name" = "support.null-audio-sink";
            "node.name" = "Microphone-Proxy";
            "node.description" = "Microphone";
            "media.class" = "Audio/Source/Virtual";
            "audio.position" = "MONO";
          };
        }
        {
          factory = "adapter";
          args = {
            "factory.name" = "support.null-audio-sink";
            "node.name" = "Main-Output-Proxy";
            "node.description" = "Main Output";
            "media.class" = "Audio/Sink";
            "audio.position" = "FL,FR";
          };
        }
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

  services.roon-server = {
    enable = true;
    openFirewall = true;
  };

  services.dbus.packages = [ pkgs.nordpkgs.openvpn3 ];

  services.flatpak.enable = true;

  services.yubikey-agent.enable = true;

  services.gnome.gnome-keyring.enable = true;

  #
  # Systemd
  #
  #

  systemd.services.systemd-udev-settle.enable = false;

  systemd.services.NetworkManager-wait-online.enable = false;

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

  # Disable `sudo`
  security.sudo.enable = false;

  # Enable `doas`
  security.doas = {
    enable = true;
    wheelNeedsPassword = false;
  };

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

  virtualisation.virtualbox.host.enable = true;

  virtualisation.docker.enable = true;

  virtualisation.libvirtd.enable = true;

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

  programs.dconf.enable = true;

  programs.ssh.askPassword =
    pkgs.lib.mkForce "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";

  #
  # USERS
  #

  users = {
    users.dnordstrom = {
      isNormalUser = true;
      extraGroups = [ "audio" "wheel" "input" "libvirtd" "vboxusers" ];
      shell = pkgs.zsh;
    };
    users.openvpn = {
      isSystemUser = true;
      group = "openvpn";
    };
    groups = { openvpn = { }; };
  };

  #
  # SYSTEM ENVIRONMENT
  #

  environment.variables = {
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
  };

  environment.pathsToLink =
    [ "/share/zsh" ]; # Completion for system packages, e.g. systemctl

  environment.loginShellInit = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      dbus-run-session sway
    fi
  '';

  environment.systemPackages = with pkgs; [
    git
    nodejs
    nordpkgs.openvpn3
    ntfs3g
    polkit_gnome
    qt5.qtwayland
    refind
    roon-server
    steam-run # Runs binaries compiled for other distributions
    wget
    xdg-desktop-portal
    yarn
  ];
}

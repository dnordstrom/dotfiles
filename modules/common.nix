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
    package = pkgs.pulseaudioFixPackages.pipewire;

    enable = true;
    systemWide = false;

    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    media-session.enable = false;

    config.pipewire = {
      "context.properties" = {
        "link.max-buffers" = 64;
        "log.level" = 2;
        "default.clock.rate" = 192000;
        "default.clock.allowed-rates" =
          [ 44100 48000 88200 96000 192000 384000 ];
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 1024;
        "core.daemon" = true;
        "core.name" = "pipewire-0";
      };
      "context.spa-libs" = {
        "audio.convert.*" = "audioconvert/libspa-audioconvert";
        "support.*" = "support/libspa-support";
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
        {
          "name" = "libpipewire-module-filter-chain";
          "args" = {
            "node.name" = "rnnoise_source";
            "node.description" = "Noise Canceling Source";
            "media.name" = "Noise Canceling Source";
            "filter.graph" = {
              nodes = [{
                type = "ladspa";
                name = "rnnoise";
                plugin =
                  "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                label = "noise_suppressor_stereo";
                channels = 2;
                control = { "VAD Threshold (%)" = 50.0; };
              }];
            };
            "capture.props" = { "node.passive" = true; };
            "playback.props" = { "media.class" = "Audio/Source"; };
          };
        }
      ];

      "stream.properties" = {
        "node.latency" = "1024/192000";
        "resample.quality" = 10;
        "resample.disable" = true;
      };
    };

    media-session.config.alsa-monitor = {
      rules = [{
        matches = [{ "node.name" = "alsa_output.*"; }];
        actions = {
          update-props = {
            "audio.format" = "S32LE";
            "audio.rate" = 192000;
            "api.alsa.period-size" = 256;
            "api.alsa.headroom" = 1024;
          };
        };
      }];
    };
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

  # Fix for pulseaudio systemd.user.services.pipewire-pulse.path = [ pkgs.pulseaudio ];

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
            max_fps = 60;
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
      extraGroups = [
        "audio"
        "wheel"
        "input" # For ydotool udev rule
        "libvirtd"
        "vboxusers"
      ];
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
    [[ "$(tty)" == /dev/tty2 ]] && sway
  '';

  environment.systemPackages = with pkgs; [
    git
    nodejs
    nordpkgs.openvpn3
    polkit_gnome
    roon-server
    steam-run # Runs binaries compiled for other distributions
    wget
    xdg-desktop-portal
    yarn
    refind
    qt5.qtwayland
  ];
}

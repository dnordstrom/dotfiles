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

    # CPU scheduling policy for Nix daemon process. Defaults to "other". Other options are "batch"
    # (for non-interactive) and "idle" (for low priority). We set it to "idle" in an attempt to be
    # able to use the PC during builds. (Documentation recommends this on desktop.)
    daemonCPUSchedPolicy = "idle";

    # IO scheduling class for Nix daemon process. Defaults to "best-effort". We set it to "idle" in
    # an attempt to be able to use the PC during builds. (Documentation recommends this on desktop.)
    daemonIOSchedClass = "idle";

    # Build settings
    settings = {
      # Number of cores used per one build (if it has parallel building enabled).
      cores = 4;

      # Max build jobs to run in parallel.
      max-jobs = 2;

      # Users with elevated `nix` command privileges.
      trusted-users = [ "root" "dnordstrom" ];

      # Automatically symlink identical files.
      auto-optimise-store = true;
    };

    # Automatically have nix daemon symlink identical files weekly to free storage space.
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    # Automatically have nix daemon remove unused packages after 30 days.
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Disable annoying warning about dirty Git tree.
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
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        netbootxyz.enable = true;
        memtest86.enable = true;
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
    dhcpcd.enable = false;
    enableIPv6 = true;
    firewall.enable = true;
    hostName = "nordix";
    networkmanager.enable = false;
    useDHCP = true;
    useNetworkd = true;
    wireless.enable = false;
    wireguard = {
      enable = true; # Includes tools, services, and WireGuard kernel module.
    };
  };

  #
  # FONTS
  #

  fonts.fonts = with pkgs;
    [ (nerdfonts.override { fonts = [ "Iosevka" "Hack" ]; }) ];

  #
  # SERVICES
  #

  services = {
    #
    # Input
    #

    xserver.libinput.enable = true;

    #
    # CPU
    #

    cpupower-gui.enable = false; # Use cpupower-gui instead of TLP.
    tlp.enable = false; # Make sure TLP stays disabled.

    #
    # Login manager
    #

    greetd = {
      enable = true;
      vt = 5;
      settings = {
        default_session = {
          command =
            "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd /home/dnordstrom/.config/river/start";
          user = "greeter";
        };
      };
    };

    #
    # Key remapping
    #

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

    #
    # Smart card daemon, for hardware keys.
    #

    pcscd = {
      enable = true;
      plugins = [ pkgs.ccid ];
    };

    #
    # OpenSSH, Bluetooth, and udev rules.
    #

    openssh.enable = true;

    blueman.enable = true;

    udev.packages = [ pkgs.nordpkgs.udev-rules ];

    #
    # Audio using PipeWire with Wireplumber as session manager.
    #

    pipewire = {
      # Enable the service.
      enable = true;

      # Use PipeWire as primary audio server (enabled by default).
      audio.enable = true;

      # Enable ALSA.
      alsa = {
        enable = true;
        support32Bit = true;
      };

      # Use PulseAudio emulation where PipeWire isn't supported.
      pulse.enable = true;

      # Use Wireplumber for modular session and policy management.
      wireplumber.enable = true;

      # Use 44.1 KHz by default and specify allowed sample rates of DAC.
      config.pipewire.context.properties = {
        default.clock = {
          rate = 44100;
          allowed-rates = [ 44100 48000 88200 96000 176400 192000 384000 ];
        };
        core.daemon = true;
        core.name = "pipewire-0";
      };
    };

    # Roon Server as systemd service
    roon-server = {
      enable = true;
      openFirewall = true;
    };

    # Packages that use `dbus` go here.
    dbus = {
      enable = true;
      packages = with pkgs; [ protonvpn-cli_2 ];
    };

    # Miscellaneous.
    flatpak.enable = true;
    yubikey-agent.enable = true;
  };

  #
  # Systemd
  #

  systemd = {
    services = {
      # Avoid waiting time on boot or shutdown.
      systemd-udev-settle.enable = false;
    };

    network = {
      wait-online.timeout = 0;

      # Insert WireGuard interfaces here:
      #
      #   netdevs = {
      #     "10-wg0" = {
      #       netdevConfig = {
      #         Kind = "wireguard";
      #         MTUBytes = "1300";
      #         Name = "wg0";
      #       };
      #       extraConfig = ''
      #         [WireGuard]
      #         PrivateKeyFile=/run/keys/wireguard-privkey
      #         ListenPort=9918
      #
      #         [WireGuardPeer]
      #         PublicKey=OhApdFoOYnKesRVpnYRqwk3pdM247j8PPVH5K7aIKX0=
      #         AllowedIPs=fc00::1/64, 10.100.0.1
      #         Endpoint={set this to the server ip}:51820
      #       '';
      #     };
      #   };
    };
  };

  #
  # SECURITY
  #

  security = {
    # Yubikey authentication, reads tokens from `~/.yubico/authorized_yubikeys`.
    pam.yubico = {
      enable = true;
      id = "70449";

      # Use with Yubico Cloud client instead of setting up challenge-response.
      mode = "client";

      # Allow login with Yubikey or password only, rather than as MFA. Bad. Convenient, but bad.
      control = "sufficient";
    };

    # Disable `sudo` in favor of `doas`.
    sudo.enable = false;

    # Enable `doas`.
    doas = {
      enable = true;
      wheelNeedsPassword = false;
    };

    # RealtimeKit service for on-demand real-time scheduling priority. The NixOS wiki recommends
    # this for PulseAudio.
    rtkit.enable = true;

    # PolicyKit for privilege escalation.
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

  # Sound should be set to disabled when using PipeWire, for whatever reason.
  sound.enable = false;

  hardware = {
    # Disable PulseAudio for PipeWire.
    pulseaudio.enable = false;

    # Enable OpenGL. This is done automatically when using the `programs.sway` module to install
    # Sway. We don't, so we enable it here. The same goes for e.g. `services.polkit.enable`.
    opengl = {
      # This would be enabled automatically if we used `programs.sway.enable`, but we're not using
      # that so let's set this here to be sure.
      enable = true;

      # Enable Direct Rendering for 32-bit applications (only 64-bit by default).
      driSupport32Bit = true;
    };

    # Enable Bluetooth.
    bluetooth = {
      enable = true;
      package = pkgs.bluezFull; # Full version includes plugins.

      # Enable support for HSP and HFP profiles.
      hsphfpd.enable = true;

      # Enable audio source and sink.
      settings.General.Enable = "Source,Sink,Media,Socket";
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

      # Configure screen sharing using `slurp` as picker.
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

  programs = {
    dconf.enable = true;

    ssh.askPassword =
      pkgs.lib.mkForce "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";

    openvpn3.enable = true;
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
        # Normal user gets a directory in `/home`.
        isNormalUser = true;

        # Extra groups for audio, input gestures, etc.
        extraGroups = [
          "wheel"
          "audio"
          "input"
          "kvm"
          "libvirtd"
          "qemu-libvirtd"
          "vboxusers"
        ];

        # Default to Zsh in TTY.
        shell = pkgs.zsh;
      };

      openvpn = {
        isSystemUser = true;
        description = "OpenVPN user";
        group = "openvpn";
      };
    };

    groups.openvpn = { };
  };

  #
  # SYSTEM ENVIRONMENT
  #

  #
  # Qt style
  #
  #   Automatically installs packages depending on settings. We use `qt5ct`, which installs
  #   `pkgs.libsForQt5.qt5ct`, a GUI configuration tool for Qt.
  #

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

  #
  # Packages, library paths, and shell initialization.
  #

  environment = {
    # System-wide software.
    systemPackages = with pkgs; [
      git
      nodejs
      polkit_gnome
      roon-server
      steam-run
      wget
      xdg-desktop-portal
      yarn
    ];

    # Directories to be symlinked in `/run/current-system/sw`.
    pathsToLink = [ "/share/zsh" "/libexec" ];

    # Launch window manager depending on TTY instead of using a display/login manager:
    #
    # * tty1 -> River
    # * tty2 -> Sway
    loginShellInit = ''
      [ "$(tty)" = "/dev/tty1" ] && exec /home/dnordstrom/.config/river/start
      [ "$(tty)" = "/dev/tty2" ] && exec /home/dnordstrom/.config/sway/start
    '';
  };
}

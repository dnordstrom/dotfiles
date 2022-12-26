{ config, pkgs, stdenv, lib, ... }:

let
  # Yes, this is, in fact, my actual username..
  username = "dnordstrom";

  # No, this isn't my actual password. You'd want a Yubikey too—will trade for Bowmore 1965 edition.
  password = "Hehe, jk.";

  # Paths of all types and shapes.
  homeDirectory = "/home/${username}";
  mediaDirectory = "${homeDirectory}/Videos"; # Plex library.
  musicDirectory = "${homeDirectory}/Music"; # Roon library.
in {
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
    extraOptions = "warn-dirty = false";
  };

  #
  # Package configuration
  #

  nixpkgs.config = {
    allowUnsupportedSystem = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "corefonts" "slack" ];
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
        netbootxyz.enable = false;
        memtest86.enable = false;
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
  # We use `systemd-networkd` for configuring networks, disabling NetworkManager. It handles the
  # configuration using DHCP for both ethernet and wireless connections. The wireless one only ever
  # used to tether using cellular data during outages or out somewhere.
  #
  # Wireless networks, access points, network cards, device scanning and monitoring, connecting, and
  # so on, is all handled by `iwctl`, a convenient helper for controlling wireless interfaces.
  #

  networking = {
    dhcpcd.enable = false;
    firewall.enable = true;
    networkmanager.enable = false;

    enableIPv6 = true;
    hostName = "nordix";
    useDHCP = true;
    useNetworkd = true;

    wireless.iwd.enable = true; # Modern security. Relatively.
    wireless.iw.enable = true; # Ancient security. Definitely.

    wireguard = {
      enable = true; # Includes tools, services, and WireGuard kernel module.
    };
  };

  #
  # FONTS
  #

  fonts.fonts = with pkgs;
    [
      (nerdfonts.override {
        fonts = [
          "3270"
          "Agave"
          "AnonymousPro"
          "Arimo"
          "AurulentSansMono"
          "BitstreamVeraSansMono"
          "CascadiaCode"
          "CodeNewRoman"
          "Cousine"
          "DaddyTimeMono"
          "FantasqueSansMono"
          "FontPatcher"
          "Gohu"
          "Hack"
          "Hasklig"
          "HeavyData"
          "Hermit"
          "IBMPlexMono"
          "Iosevka"
          "Lekton"
          "Linex"
          "MPlus"
          "Monofur"
          "Monoid"
          "Mononoki"
          "NerdFontsSymbolsOnly"
          "Noto"
          "Overpass"
          "ProFont"
          "ProggyClean"
          "RobotoMono"
          "ShareTechMono"
          "SourceCodePro"
          "SpaceMono"
          "Terminus"
          "Tinos"
          "Ubuntu"
          "UbuntuMono"
          "iA-Writer"
        ];
      })
    ];

  #
  # SERVICES
  #

  services = {
    #
    # Input
    #

    xserver.libinput.enable = true;

    #
    # Output
    #

    kanshi = {
      extraConfig = "";
      profiles = {
        nordix = {
          outputs = [
            {
              criteria = "DP-1";
              mode = "3440x1440@99.982Hz";
              position = "2397,780";
              status = "enable";
            }
            {
              criteria = "DP-2";
              mode = "1920x1080@144.001Hz";
              position = "0,1349";
              status = "enable";
            }
            {
              criteria = "DVI-D-1";
              mode = "1920x1080@60Hz";
              position = "0,0";
              scale = "0.8";
              status = "enable";
            }
            {
              # Connected to the same monitor as DP-1 and can be disabled.
              criteria = "HDMI-A-1";
              status = "disable";
            }
          ];
        };
      };
    };

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
            "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd ${homeDirectory}/.config/river/start";
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

    # Using `bluetoothd`, `bluetoothctl`, and `BlueZ` for BT audio.
    blueman.enable = false;
    openssh.enable = true;
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
      config.pipewire = {
        "context.properties" = {
          "core.daemon" = true;
          "core.name" = "pipewire-0";
          "default.clock.rate" = 44100;
          "default.allowed-rates" =
            [ 44100 48000 88200 96000 176400 192000 384000 ];
          "link.max-buffers" = 16;
        };
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

    # Plex media server
    plex = {
      enable = true;
      openFirewall = true;
      dataDir = mediaDirectory;
    };

    # Flatpak agent.
    flatpak.enable = true;

    # Yubikey agent.
    yubikey-agent.enable = true;
  };

  #
  # Systemd
  #

  systemd = {
    services = { systemd-udev-settle.enable = false; };

    network = {
      # Avoid waiting time on boot or shutdown.
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
  # `isNormalUser = true;` creates a home directory while `isSystemUser = true;` doesn't. For
  # appropriate access, users need to be in the right groups, such as "input" for libinput, or
  # "audio" for the Roon Server user.
  #
  # Remember to add all the groups you need to your user. Groups created by Nix modules aren't very
  # visible, which is the whole point of abstracting it into a module. E.g., reading `openvpn3.nix`
  # below tells us that it adds a system user (no home directory) "openvpn", in a new group 
  # "openvpn", and adds itself to the the list of packages requiring D-BUS access. Many modules let
  # you specify which user and group should be used to run a service, but you'll often need to add
  # the group to your user since the module doesn't know or care who you are. Including "openvpn"
  # below lets me do my job, which is nice, and "audio" even lets me listen to music.
  #
  # See: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/openvpn3.nix
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
          "openvpn"
          "plex"
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
      wget
      xdg-desktop-portal
      yarn
    ];

    # Directories to be symlinked in `/run/current-system/sw`.
    pathsToLink = [ "/share/zsh" "/libexec" ];

    # Initially, what window manager we launched depended on TTY used to log in, rather than a GUI
    # display manager. Currently, we're kind of in the middle using `agetty`, a TUI login manager.
    # We do so, for now, because it's nearly plain TTY fast, can launch different sessions without
    # `Ctrl+Alt+F2` to switch TTY, plays well with hardware keys, has easily accessible reboot and 
    # shutdown options (oftentimes logging in to run `systemctl reboot`, or even just `reboot`, is
    # the difference between life and death!), and it lets me type a custom command to run on login.
    #
    # Mine's a script that does some D-BUS and `systemd` magic before launching `river`, which will
    # run any executable found at `~/.config/river/init`. Mine's another shell script, since it's
    # basic. Hobby: Rust or Python just to learn. Professionally: if I'm all alone, Lua, for being
    # fast, simple, and fun to use in Neovim—useful knowledge. Rust could avoid constant compiling
    # if you use some configuration library and call `riverctl` accordingly. But that would defeat
    # the purpose; rather than make lives simpler, we actually *add* the complexity of a whole new
    # layer of configuration on top of the current layer. It's technology's way to put carpet floor
    # and wallpaper on top of six old layers, thinking "haha, I won't live here long enough anyway,
    # but damn, going to suck for the who has to remove all this crap!"
    #
    # * tty1 -> River
    # * tty2 -> Sway
    loginShellInit = ''
      [ "$(tty)" = "/dev/tty2" ] && exec /home/dnordstrom/.config/river/start
      [ "$(tty)" = "/dev/tty3" ] && exec /home/dnordstrom/.config/sway/start
    '';
  };
}

{ config, pkgs, stdenv, lib, inputs, ... }:

let
  autocleanEnable = true; # Optimize and garbage collect (daemon and on build).
  autocleanFrequency = "weekly"; # How often the daemon should do optimizations.
  autocleanOlderThan = "30d"; # How long to keep generations before deleting.

  username = "dnordstrom";
  password = "Who knows?";

  defaultBrowser = "firefox";
  defaultEditor = "nvim";

  homeDirectory = "/home/${username}";

  # To avoid some issues with the XDG portals, this does basically the same thing as the Nix module,
  # but we can see it and tweak as needed. `xdgPortalsJoinedPackagesEnv` creates a package
  # environment containing all portal outputs in one place, simpler to link or mess around with.
  xdgPortalsPackage = [ pkgs.xdg-desktop-portal ];
  xdgPortalsExtraPackages = with pkgs; [
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
  ];
  xdgPortalsJoinedPackages = xdgPortalsPackage ++ xdgPortalsExtraPackages;
  xdgPortalsJoinedPackagesEnv = pkgs.buildEnv {
    name = "xdg-portals";
    paths = xdgPortalsJoinedPackages;
    pathsToLink = [ "/share/xdg-desktop-portal/portals" "/share/applications" ];
  };
in {
  #
  # IMPORTS
  #

  imports = [ ../cachix.nix ];

  #
  # GENERAL
  #

  system.stateVersion = "23.11"; # You don't want to do this, keep it as is.

  time.timeZone = "Europe/Stockholm";

  nix = {
    # Use unstable `nix` CLI tool, because we can.
    package = pkgs.nixUnstable;

    # CPU scheduling policy for Nix daemon process. Defaults to "other". Other options are "batch"
    # (for non-interactive) and "idle" (for low priority). We set it to "idle" in an attempt to be
    # able to use the PC during builds. (Documentation recommends this on desktop.)
    daemonCPUSchedPolicy = "idle";

    # IO scheduling class for Nix daemon process. Defaults to "best-effort". We set it to "idle" in
    # an attempt to be able to use the PC during builds. (Documentation recommends this on desktop.)
    daemonIOSchedClass = "idle";

    # Build settings.
    settings = {
      # Number of cores per one build if the derivation has parallel building enabled, and max
      # builds to run in parallel. You probably don't want to touch this, but I like my PC to remain
      # semi-responsive while rebuilding, crashing Firefox less than twice a minute.
      cores = 1;
      max-jobs = 2;

      # Elite users with elevated `nix` command privileges that allow rebuilding NixOS.
      trusted-users = [ "root" "dnordstrom" ];

      # Automatically perform store optimizations when rebuilding.
      auto-optimise-store = autocleanEnable;
    };

    # Kindly ask Nix daemon to auto-optimize the Nix store by symlinking identical files weekly.
    optimise = {
      automatic = autocleanEnable;
      dates = [ autocleanFrequency ];
    };

    # Kindly ask Nix daemon to auto-optimize the Nix store by garbage collecting old generations and
    # builds weekly. Ever had a build fail after obliterating your last 20GB? Then you get it.
    gc = {
      automatic = autocleanEnable;
      dates =
        autocleanFrequency; # Why this is a string but `optimise.dates` a list, I don't know.

      # Garbage collect weekly, but keep generations for 30 days since we suck at updating things.
      options = "--delete-older-than ${autocleanOlderThan}";
    };

    # Disable warning about dirty Git tree. Running `git status` every other minute is far superior.
    extraOptions = "warn-dirty = false";
  };

  #
  # PACKAGE MANAGEMENT
  #

  # Mostly stuff we don't want to do but need to due to shit package maintenance.
  nixpkgs.config = {
    allowUnsupportedSystem = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "corefonts" "slack" ];
    permittedInsecurePackages = [ "openssl-1.1.1u" ];

    # This installs the native messaging client for the Tridactyl Firefox add-on though.
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
    hostName = "nordix"; # TODO: Automate "nordix" vs. "nordix-laptop".
    enableIPv6 = true; # Running out of IPv4 addresses? Fine.
    useDHCP = true; # Some recommend false and enabling individual interfaces.
    useNetworkd = true; # Use `networkd` instead of `NetworkManager`.
    firewall.enable = false; # TODO: Enable after fixing Plex and Roon ARC.
    networkmanager.enable = false; # Using `networkd` instead.
    wireless.iwd.enable = true; # Includes `iwctl` wireless networking CLI.
    wireguard.enable = true; # Includes tools, services, and kernel module.
    dhcpcd.enable = false; # Handled by `networkd`, can be disabled.

    # Hostnames written to `/etc/hosts`.
    hosts = {
      "::1" = [ "localhost" ];
      "127.0.0.1" = [ "localhost" ];
      "10.1.1.1" = [ "router.local" "gateway.local" ]; # ISP-provided gateway.
      "10.1.1.2" = [ "homeassistant.local" "nordix.local" ]; # Main workstation.
      "10.1.1.3" = [ "nordix.tv" ]; # Samsung Smart TV.
      "10.1.1.4" = [ "nordix.mobi" ]; # iPhone.
    };
  };

  #
  # FONTS
  #
  # In terminal emulators, PragmataPro Mono with ligatures and 10,000 glyphs is the love of my life.
  # Unfortunately, I can't include it due to licensing. But if you go for it, simply download the
  # OpenType files from the store and extract them to `~/.local/share/fonts`. It's 115% worth it.
  #
  # For GUI, we use "Public Sans" regular at 9-10.5pt. Formerly we used a customized Input Mono for
  # terminals and Input Sans Condensed for UI, they're fantastic as well, and customizable.
  #
  # REFERENCES:
  #
  #   * Installed fonts list: `fc-list --verbose/--brief | grep [options]`
  #   * Generated fontconfig: `/var/run/booted-system/etc/fonts/conf.d`
  #

  fonts = {
    fontconfig = {
      antialias = true;
      useEmbeddedBitmaps = true;

      defaultFonts = {
        emoji = [ "Twemoji" ];
        sansSerif = [ "PT Sans" "Symbols Nerd Font" ];
        serif = [ "PT Serif" "Symbols Nerd Font" ];
        monospace = [ "PragmataPro Mono Liga" "Symbols Nerd Font" ];
      };

      hinting = {
        autohint = false;
        enable = true;
        style = "slight";
      };

      subpixel = {
        lcdfilter = "default";
        rgba = "rgb";
      };
    };

    fonts = [
      (pkgs.nerdfonts.override {
        fonts = [
          "BitstreamVeraSansMono"
          "CascadiaCode"
          "CodeNewRoman"
          "DaddyTimeMono"
          "FantasqueSansMono"
          "Hack"
          "IBMPlexMono"
          "Iosevka"
          "MPlus"
          "NerdFontsSymbolsOnly"
          "Noto"
          "Overpass"
          "SourceCodePro"
          "iA-Writer"
        ];
      })
    ];
  };

  #
  # CONSOLE/TTY
  #

  # Use xserver keyboard settings at virtual console/TTY.
  console = {
    earlySetup = true;
    useXkbConfig = true;
  };

  #
  # SERVICES
  #

  services = {
    #
    # Enable libinput for Wayland mouse and touchpad setup.
    #
    xserver = {
      enable = false;
      libinput.enable = true;
      layout = "us,se";
      xkbVariant = ",";
    };

    #
    # DDC Control for controlling monitor settings.
    #

    ddccontrol.enable = true;

    #
    # Enable GUI for CPU frequency scheduling.
    #

    cpupower-gui.enable = true;

    #
    # Enable hip ebook manager and dank web UI.
    #

    calibre-server = {
      enable = true;
      libraries = [ /home/dnordstrom/Documents/calibre-library ];
    };

    calibre-web = {
      enable = true;
      openFirewall = true;
      listen = {
        ip = "10.1.1.2";
        port = 8083;
      };
      options = {
        calibreLibrary = /home/dnordstrom/Documents/calibre-library;
        enableBookUploading = true;
        enableBookConversion = true;
      };
    };

    #
    # Smart home setup.
    #

    home-assistant = {
      enable = true;
      configWritable = true;
      openFirewall = true;

      config = {
        homeassistant = {
          name = "nordix.home";
          latitude = 62.38;
          longitude = 17.32;
        };
        http = {
          server_port = 8123;
          server_host = [
            "10.1.1.2"
            "127.0.0.1"
            "homeassistant.local"
            "fe80::692:26ff:fed3:4647"
          ];
        };
      };

      extraComponents = [
        # Set of sane default components, listed in the documentation:
        # https://www.home-assistant.io/integrations/default_config
        "default_config"
        "apple_tv" # Apple TV control.
        "browser" # Open URLs on host machine.
        "caldav" # Calendar.
        "camera" # IP camera support.
        "cast" # For Google/Chrome casting.
        "configurator" # Can request information from user.
        "dlna_dms" # DLNA streaming support.
        "ffmpeg" # FFmpg processing.
        "flux" # Adjust lighting based on sun.
        "google_assistant"
        "homekit" # For controlling Home Assistant from the Apple Home app.
        "homekit_controller" # For adding HomeKit devices to Home Assistant.
        "hue" # Philips Hue support.
        "ios" # iPhone support.
        "jellyfin" # Media server.
        "keyboard" # Support keyboard devices.
        "kodi" # Media player.
        "mastodon" # Mastodon notifications.
        "matter" # Beta Matter and Thread support.
        "matrix" # Matrix notification support.
        "media_player" # Interacts with various media players.
        "plex" # Media server.
        "pocketcasts" # Premium standalone podcast player for Apple Watch (and more).
        "rest_command" # Call REST APIs.
        "roborock" # Robot vacuum cleaner.
        "roon" # Control Roon music player.
        "shell_command" # Run arbitrary commands.
        "smartthings" # Samsung SmartThings integration, for smart TV and more.
        "tradfri" # IKEA gateway with Zigbee and eventual Matter support.
        "twitter" # Twitter control.
      ];
    };

    #
    # Use `tuigreet` as TUI login manager.
    #

    greetd = {
      enable = true;
      vt = 3; # TTY 1 and 2 will start Sway or River on login, respectively.
      settings = {
        default_session = {
          command =
            "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --asterisks --cmd ${homeDirectory}/.config/river/start";
          user = "greeter";
        };
      };
    };

    #
    # Keyboard
    #

    # Remap keys using Interception Tools plugins. Works in TTY.
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
    # Smart card daemon for hardware keys.
    #

    pcscd = {
      enable = true;
      plugins = [ pkgs.ccid ];
    };

    #
    # Network and Bluetooth services.
    #

    blueman.enable = false;

    openssh.enable = true;

    udev.packages = [ pkgs.nordpkgs.udev-rules ];

    #
    # Audio
    #

    # Enable PipeWire audio server. Adds systemd services. The config lives in `~/.config/pipewire`,
    # or `/etc/pipewire` if using a system-wide setup. NixOS and PipeWire docs recommend using user
    # rather than system services. User services and socket activation is enabled by default.
    pipewire = {
      enable = true;
      systemWide = false;
      pulse.enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    # Roon Server as systemd service
    roon-server = {
      enable = true;
      openFirewall = true;
    };

    # Plex media server.
    plex = {
      enable = true;
      openFirewall = true;
    };

    # Jellyfin Media Server.
    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    #
    # Miscellaneous, other stuff.
    #

    # Packages that need system D-Bus access go in the list below. Usually the NixOS modules will
    # take care of this.
    dbus = {
      enable = true;
      packages = [ inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin ];
    };

    # Enable Flatpak agent service.
    flatpak.enable = true;

    # Enable Yubikey agent for hardware security keys.
    yubikey-agent.enable = true;
  };

  #
  # SYSTEMD
  #

  systemd = {
    #
    # Packages
    #

    packages = [ inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin ]
      ++ xdgPortalsJoinedPackages;

    #
    # Services
    #

    services.systemd-udev-settle.enable = false;

    #
    # Systemd-networkd
    #

    network = {
      # Avoid waiting time on boot or shutdown.
      wait-online.timeout = 0;

      # Insert WireGuard interfaces here.
      netdevs = { };
    };
  };

  #
  # SECURITY
  #

  security = {
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

    pam = {
      # Yubikey hardware key authentication.
      yubico = {
        enable = true;
        id = "70449";
        mode = "client"; # Yubico Cloud client instead of challenge-response.
        control = "sufficient"; # Allow login with key or password only. BAD.
      };
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

  # Disable system-wide ALSA setup, since we're using PipeWire's ALSA emulation. Enabling this can
  # let us use media keys in TTY, for example.
  sound.enable = false;

  hardware = {
    # Disable PulseAudio since we use PipeWire.
    pulseaudio.enable = false;

    # Enable OpenGL. This is done automatically when using the `programs.sway` module to install
    # Sway. We don't, so we enable it. The same goes for e.g. `services.polkit.enable`.
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };

    # Enable Bluetooth.
    bluetooth = {
      enable = true;
      settings.General.Enable = "Source,Sink,Media,Socket";
    };

    uinput.enable = true;
  };

  #
  # XDG
  #

  xdg = {
    menus.enable = true;
    icons.enable = true;

    portal = {
      enable = true;
      extraPortals = xdgPortalsExtraPackages;
      xdgOpenUsePortal = true;

      # Configure screen sharing using `slurp` as picker.
      wlr = {
        enable = true;
        settings = {
          screencast = {
            max_fps = 60;
            output_name = "HDMI-A-1";
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
    zsh.enable = true;
    dconf.enable = true;
    ssh.askPassword =
      pkgs.lib.mkForce "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
    openvpn3.enable = true;
  };

  #
  # USERS
  #   
  # `isNormalUser = true` creates a home directory while `isSystemUser = true` doesn't. For
  # appropriate access, remember to add users to the right groups, e.g. "input" for libinput, or
  # "audio" for Roon Server.
  #

  users = {
    users = {
      dnordstrom = {
        # Normal user gets a directory in `/home`.
        isNormalUser = true;

        # Extra groups for audio, input gestures, etc.
        extraGroups = [
          "audio"
          "input"
          "kvm"
          "libvirtd"
          "openvpn"
          "plex"
          "qemu-libvirtd"
          "uinput"
          "vboxusers"
          "wheel"
        ];

        # Use Zsh as user shell.
        shell = pkgs.zsh;
      };
    };
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

  qt = {
    enable = true;

    # This sets the `QT_QPA_PLATFORMTHEME` environment variable. The `qt5ct` app will determine the
    # Kvantum theme, icons, fonts, widget style, and so on.
    platformTheme = "qt5ct";

    #
    # This sets the `QT_STYLE_OVERRIDE` environment variable, which overrides the widget style only.
    # We skip it, since running `qt5ct` is cooler than rebuilding.
    #
    # Options reference:
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
    # Add `~/.local/bin` to `PATH`.
    localBinInPath = true;

    # Crap we "need" installed at system level rather than user, like audio and PCI tools.
    systemPackages = with pkgs; [
      git
      libva-utils
      libsForQt5.polkit-qt
      roon-server
      wget
      glib
      xdg-utils
      wireplumber
      alsa-tools
      pulseaudio
      alsaUtils
      pciutils
      xkeyboard_config
      xorg.setxkbmap
      xorg.xinput
    ];

    # These are set on login for all users. (I.e., for me and myself.)
    sessionVariables = {
      BROWSER = defaultBrowser;
      EDITOR = defaultEditor;

      # XDG portals
      GTK_USE_PORTAL = "1";

      # Firefox
      MOZ_DBUS_REMOTE = "1";
      MOZ_USE_XINPUT2 = "1";
      MOZ_ENABLE_WAYLAND = "1";

      # Wayland
      GDK_BACKEND = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      XDG_CURRENT_DESKTOP = "river";
      XDG_SESSION_DESKTOP = "river";
      XDG_SESSION_TYPE = "wayland";

      XDG_DESKTOP_PORTAL_DIR = lib.mkForce
        "${xdgPortalsJoinedPackagesEnv}/share/xdg-desktop-portal/portals";

      # Java
      _JAVA_AWT_WM_NONREPARENTING = "1";

      # Keyboard
      XKB_DEFAULT_LAYOUT = "us,se";
      XKB_DEFAULT_OPTIONS =
        "shift:both_capslock,grp:ctrls_toggle,lv3:ralt_switch_multikey";
    };

    # Directories to be symlinked in `/run/current-system/sw`.
    pathsToLink = [
      "/share/zsh"
      "/libexec"
      "/share/xdg-desktop-portal/portals"
      "/share/applications"
    ];

    # Before `getty`, logging in at `tty1` started Sway and `ttY2` started River. Faster than a
    # display manager. The `agetty` TUI login manager gives clean UI that pops up crazy fast.
    #
    # It also simplifies choosing window manager (no `Ctrl+Alt+F2`), allows changing launch command
    # at login screen, supports hardware keys, and makes shutdown options available via key bind.
    #
    # The River `start` script does some D-BUS and `systemd` magic, then it runs `river`. River will
    # run whatever is at `~/.config/river/init`. Here it's a shell script, but Lua would be neat.
    # Rust would be cool, probably orders of magnitute faster than today's 0.28 second launch time!
    #
    # * tty1 -> No WN. Confuses those who have the audacity(!) to touch other people's shit.
    # * tty2 -> River WM
    # * tty3 -> Sway WM
    loginShellInit = ''
      [ "$(tty)" = "/dev/tty2" ] && exec /home/dnordstrom/.config/river/start
      [ "$(tty)" = "/dev/tty3" ] && exec /home/dnordstrom/.config/sway/start
    '';
  };
}

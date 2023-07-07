# #
# DNORDSTROM USER CONFIGURATION
#
# Author:       Daniel Nordstrom <d@mrnordstrom.com>
# Repository:   https://github.com/dnordstrom/dotfiles
# #  

{ pkgs, lib, config, inputs, ... }:

let
  ##
  # SETUP
  ##

  username = "dnordstrom";
  buildDirectory = "/etc/nixos";
  homeDirectory = "/home/${username}";
  kittySessionsDirectory = "${buildDirectory}/config/kitty/sessions";

  mkSymlink = config.lib.file.mkOutOfStoreSymlink;

  # Convenience method for getting absolute paths based on `buildDirectory`. Leading slash not needed.
  # The `/. +` part coerces the type from string to path.
  #
  # @param {string|path} path - Relative path.
  # @returns {path} Absolute path.
  mkConfigPath = path: /. + "${buildDirectory}/config/${path}";

  # Convenience method for getting absolute paths based on build configuration directory. Leading slash
  # not needed. The `/. +` part coerces the type from string to path.
  #
  # @param {string|path} path - Relative path.
  # @returns {path} Absolute path.
  mkBuildPath = path: /. + "${buildDirectory}/${path}";

  # Convenience method to convert relative path to absolute, based on the user's home directory.
  #
  # @param {string|path} path - Relative input.
  # @returns {path} path - Absolute output.
  mkHomePath = path: /. + "${homeDirectory}/${path}";

  customIconTheme = {
    name = "Papirus";
    package = pkgs.catppuccin-papirus-folders.override {
      flavor = "latte";
      accent = "yellow";
    };
  };

  customGtkTheme = {
    name = "Catppuccin-Latte-Compact-Yellow";
    package = pkgs.catppuccin-gtk.override {
      accents = [ "yellow" ];
      size = "compact";
      tweaks = [ "rimless" ];
      variant = "latte";
    };
  };

  customCursorTheme = {
    name = "Catppuccin-Latte-Yellow-Cursors";
    package = pkgs.catppuccin-cursors.latteYellow;
  };

  ##
  # APPLICATIONS
  ##

  #
  # General
  #

  browser = "firefox";
  editor = "nvim";
  terminal = "kitty";

  #
  # Desktop entries
  #

  xdgBrowser = [ "firefox.desktop" ];
  xdgEditor = [ "neovim.desktop" ];
  xdgFileBrowser = [ "org.kde.dolphin.desktop" ];
  xdgHttpie = [ "httpie.desktop" ];
  xdgImageViewer = [ "vimiv.desktop" ];
  xdgMailClient = [ "firefox.desktop" ];
  xdgMarkdown = [ "glow.desktop" ];
  xdgMediaPlayer = [ "umpv.desktop" ];
  xdgMoneroWallet = [ "mymonero.desktop" ];
  xdgPasswordManager = [ "bitwarden.desktop" ];
  xdgPdfViewer = [ "org.pwmt.zathura.desktop" ];

  ## 
  # MIME-TYPES
  ## 

  mimeAassociations = {
    "application/json" = xdgEditor;
    "application/pdf" = xdgPdfViewer;
    "application/x-compressed-tar" = xdgFileBrowser;
    "application/x-extension-htm" = xdgBrowser;
    "application/x-extension-html" = xdgBrowser;
    "application/x-extension-shtml" = xdgBrowser;
    "application/x-extension-xht" = xdgBrowser;
    "application/x-extension-xhtml" = xdgBrowser;
    "application/xhtml+xml" = xdgBrowser;
    "application/zip" = xdgFileBrowser;
    "audio/*" = xdgMediaPlayer;
    "image/*" = xdgImageViewer;
    "inode/directory" = xdgFileBrowser;
    "text/calendar" = xdgBrowser;
    "text/html" = xdgBrowser;
    "text/markdown" = xdgEditor;
    "text/plain" = xdgEditor;
    "video/*" = xdgMediaPlayer;
    "x-scheme-handler/about" = xdgBrowser;
    "x-scheme-handler/bitwarden" = xdgPasswordManager;
    "x-scheme-handler/chrome" = xdgBrowser;
    "x-scheme-handler/ftp" = xdgBrowser;
    "x-scheme-handler/http" = xdgBrowser;
    "x-scheme-handler/https" = xdgBrowser;
    "x-scheme-handler/mailto" = xdgMailClient;
    "x-scheme-handler/monero" = xdgMoneroWallet;
    "x-scheme-handler/pie" = xdgHttpie;
    "x-scheme-handler/unknown" = xdgBrowser;
  };

  #
  # PYTHON AND FRIENDS
  #

  pythonPackages = ps: with ps; [ i3ipc requests ];
  pythonWithPackages = pkgs.python3.withPackages python-packages;

  #
  # GSETTINGS
  #
  # TODO: Make it work.
  #

  profileCommands = let
    gtk3 = pkgs.gtk3;
    gsettings = pkgs.gsettings-desktop-schemas;
    gtk3-schemas = "${pkgs.gtk3.out}/share/gsettings-schemas/${gtk3.name}";
    gsettings-schemas =
      "${gsettings.out}/share/gsettings-schemas/${gsettings.name}";
  in ''
    export XDG_DATA_DIRS="${gsettings-schemas}:${gtk3-schemas}:$XDG_DATA_DIRS"
  '';
in rec {
  ##
  # ENVIRONMENT
  ##

  home = {
    stateVersion = "23.11";

    sessionVariables = {
      EDITOR = editor;
      BROWSER = browser;
      TERMINAL = terminal;
      NIXOS_OZONE_WL = "1";
    };

    sessionPath = [ "${homeDirectory}/.local/bin" ];

    extraProfileCommands = profileCommands;
  };

  ##
  # XDG DESKTOP ENTRIES AND MIME-TYPE ASSOCIATIONS
  ##

  xdg = {
    enable = true;

    mimeApps = {
      enable = true;
      associations.added = mimeAassociations;
      defaultApplications = mimeAassociations;
    };

    desktopEntries = let
      # Defaults for Firefox Nightly desktop entries we'll add for specific profiles.
      firefoxName = "Firefox Nightly";
      firefoxCategories = [ "Network" "WebBrowser" ];
      firefoxIcon = "firefox-nightly";
      firefoxMimeType = [
        "application/vnd.mozilla.xul+xml"
        "application/xhtml+xml"
        "text/html"
        "text/xml"
        "x-scheme-handler/ftp"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/mailto"
      ];
      firefoxStartupNotify = false;
      firefoxTerminal = false;
      firefoxType = "Application";
    in {
      #
      # AppImage applications
      #

      nemo = {
        name = "Nemo";
        comment = "Nemo, no Cinnamon";
        type = "Application";
        genericName = "Nemo, no Cinnamon";
        exec = "nemo %U";
        terminal = false;
        icon = "system-file-manager";
        categories = [ "GNOME" "GTK" "Utility" "Core" ];
        mimeType = [ "inode/directory" "application/x-gnome-saved-search" ];
        startupNotify = false;
      };

      httpie = {
        name = "HTTPie";
        type = "Application";
        genericName = "Modern HTTP client for the API era";
        exec =
          "appimage-run ${homeDirectory}/.local/bin/httpie/httpie.appimage %F";
        terminal = false;
        icon = "httpie";
        categories = [ "Utility" "Development" ];
        mimeType = [ "x-scheme-handler/pie" ];
        startupNotify = false;
      };

      mymonero = {
        name = "MyMonero";
        type = "Application";
        genericName = "Monero Wallet";
        exec =
          "GDK_BACKEND=x11 appimage-run ${homeDirectory}/.local/bin/mymonero/mymonero.appimage -- %U";
        terminal = false;
        icon = "mymonero";
        categories = [ "Office" "Finance" ];
        mimeType = [ "x-scheme-handler/monero" ];
        startupNotify = false;
        settings = { StartupWMClass = "MyMonero"; };
      };

      #
      # Terminal applications
      #

      vifm = {
        name = "Vifm";
        type = "Application";
        genericName = "Terminal file manager";
        exec = "kitty --title popupterm -e vifm %F";
        terminal = false;
        icon = "vifm";
        categories = [ "System" "FileManager" ];
        mimeType = [ "text/plain" "inode/directory" ];
        startupNotify = false;
      };

      glow = {
        name = "Glow";
        type = "Application";
        genericName = "Markdown viewer";
        exec = "kitty --title popupterm -e glow %F";
        terminal = false;
        icon = "kitty";
        categories = [ "Utility" "TextEditor" ];
        mimeType = [ "text/markdown" ];
        startupNotify = false;
      };

      #
      # Terminal startup automations
      #

      blogSession = {
        name = "Blog terminal";
        comment = "Writing and development session";
        genericName = "Writing and development session";
        type = "Application";
        exec = ''
          kitty --session "${buildDirectory}/config/kitty/sessions/dev-cloud.session" --single-instance --instance-group dev-cloud
        '';
        terminal = false;
        icon = "kitty";
        categories = [ "Utility" "TextEditor" "Development" "IDE" ];
        mimeType = [ "text/plain" "inode/directory" ];
        startupNotify = true;
      };

      scratchpadSession = {
        name = "Scratchpad terminal";
        comment = "Persistent scratchpad session";
        genericName = "Persistent scratchpad session";
        type = "Application";
        exec = ''
          kitty --class scratchterm --title "Scratchpad terminal" --single-instance --instance-group
          scratchterm --session "${kittySessionsDirectory}/scratchpad.session"
        '';
        terminal = false;
        icon = "kitty";
        categories = [ "Utility" "TextEditor" "Development" "IDE" ];
        mimeType = [ ];
        startupNotify = true;
      };

      #
      # Browser profiles
      #

      firefox = {
        name = "${firefoxName}";
        genericName = "Default profile";
        exec = "firefox -P Default %U";
        settings = { StartupWMClass = "firefox-nightly-default"; };
        type = firefoxType;
        terminal = firefoxTerminal;
        icon = firefoxIcon;
        categories = firefoxCategories;
        mimeType = firefoxMimeType;
        startupNotify = firefoxStartupNotify;
      };

      firefoxPrivate = {
        name = "${firefoxName}";
        genericName = "Private profile";
        exec = "firefox -P Private %U";
        settings = { StartupWMClass = "firefox-nightly-private"; };
        type = firefoxType;
        terminal = firefoxTerminal;
        icon = firefoxIcon;
        categories = firefoxCategories;
        mimeType = firefoxMimeType;
        startupNotify = firefoxStartupNotify;
      };

      firefoxTesting = {
        name = "${firefoxName}";
        genericName = "Testing profile";
        exec = "firefox -P Testing %U";
        settings = { StartupWMClass = "firefox-nightly-testing"; };
        type = firefoxType;
        terminal = firefoxTerminal;
        icon = firefoxIcon;
        categories = firefoxCategories;
        mimeType = firefoxMimeType;
        startupNotify = firefoxStartupNotify;
      };

      firefoxMusic = {
        name = "${firefoxName}";
        genericName = "Music profile";
        exec = "firefox -P Music %U";
        settings = { StartupWMClass = "firefox-nightly-music"; };
        type = firefoxType;
        terminal = firefoxTerminal;
        icon = firefoxIcon;
        categories = firefoxCategories;
        mimeType = firefoxMimeType;
        startupNotify = firefoxStartupNotify;
      };
    };
  };

  ##
  # PACKAGES
  ##

  home.packages = with pkgs; [
    #
    # Local
    #
    # These are either grabbed from the `nixpkgs` GitHub repository and tampered with---those that
    # exist but don't work---or they're written by me since they weren't available there.
    #

    nordpkgs.lswt

    #
    # Tryouts
    #
    # Maybe we keep 'em, maybe we don't. But if we don't bunch them up here, we forget 'em.
    #

    cider
    cliphist
    clipman
    copyq
    cozy
    libsForQt5.ktorrent
    proycon-wayout
    rambox
    shikane
    strawberry
    swww
    wayout
    wlrctl
    wiki-tui
    wpaperd
    input-remapper
    navi
    ytfzf
    youtube-dl # TODO: Switch to updated forks.

    #
    # Rofi and Wofi tools
    #

    emojipick
    rofi-bluetooth
    rofi-calc
    rofi-emoji
    rofi-emoji
    rofi-systemd
    rofi-wayland
    rofimoji
    wofi
    wofi-emoji

    #
    # Networking
    #

    gnunet
    gnunet-gtk
    onionshare-gui
    qbittorrent
    wg-bond

    #
    # System
    #

    agenix
    cachix
    nix-du
    nix-prefetch
    nixos-option

    #
    # Key remappers
    #

    interception-tools

    #
    # Programs, packages, and files
    #

    appimage-run
    cinnamon.nemo
    dolphin
    ffmpegthumbnailer
    fsearch
    gnome.nautilus
    nvme-cli
    unar

    #
    # Feeds
    #

    gnome-podcasts
    pocket-casts
    raven-reader

    #
    # Borrowed KDE software (and libs I don't need)
    #

    libsForQt5.ark
    libsForQt5.breeze-gtk
    libsForQt5.breeze-icons
    libsForQt5.breeze-plymouth
    libsForQt5.breeze-qt5
    libsForQt5.ffmpegthumbs
    libsForQt5.kasts
    libsForQt5.kdegraphics-thumbnailers
    libsForQt5.kdf
    libsForQt5.keditbookmarks
    libsForQt5.kfilemetadata
    libsForQt5.kgpg # Graphical GPG interface.
    libsForQt5.kio
    libsForQt5.kio-extras
    libsForQt5.kparts
    libsForQt5.okular # Document viewer needed for Kate's (or Kpart's) Markdown preview.
    libsForQt5.qt5.qtgraphicaleffects # Needed by Quaternion Matrix client.
    libsForQt5.qt5.qtimageformats
    libsForQt5.qt5.qtmultimedia
    libsForQt5.qt5.qtwayland
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugins
    qt6.qt5compat
    qt6.qt3d
    qt6.full

    #
    # Communication
    #

    element-desktop
    qtox
    slack
    tdesktop

    #
    # Command line
    #

    bottom
    fd
    gh
    libnotify
    librsvg # Sypposedly a dependency to `mdcat` for showing images.
    mdcat
    ncpamixer # TODO: Let `pavucontrol` go.
    neofetch
    onefetch
    pamixer # TODO: Let `pavucontrol` go.
    parallel
    rdrview
    ripgrep
    tree
    unzip
    usbutils
    vifm-full
    zip

    #
    # Zsh
    #

    zsh-autopair
    zsh-completions
    zsh-fzf-tab
    zsh-nix-shell
    zsh-vi-mode

    #
    # Wayland
    #

    gebaar-libinput
    grim
    imagemagick
    libinput
    libinput-gestures
    lisgd
    ristate
    river
    river-tag-overlay
    slurp
    swappy
    swaybg
    swayidle
    swaylock-effects
    vimiv-qt
    wdisplays
    wev
    wf-recorder
    wl-clipboard
    wlopm
    wshowkeys
    wtype
    ydotool

    #
    # Web
    #

    # See GH issue: https://github.com/NixOS/nixpkgs/issues/146401
    (tor-browser-bundle-bin.override { useHardenedMalloc = false; })
    tridactyl-native # Firefox native messaging host.

    #
    # Security
    #

    # Proton's official CLI and GUI apps both have GUI/DE dependencies and won't run headless. We'll
    # use `wg-quick` to start a WireGuard session instead, but let's add the CLI just in case.
    protonvpn-cli
    bitwarden
    bitwarden-cli
    git-crypt
    pinentry-qt
    yubico-pam
    yubico-piv-tool
    yubikey-agent
    yubikey-personalization
    yubikey-personalization-gui
    yubikey-touch-detector

    #
    # Multimedia
    #

    castnow
    cava
    chrome-export
    enlightenment.ephoto
    jamesdsp
    libcamera
    lxqt.pavucontrol-qt
    playerctl
    plexamp
    pulsemixer
    ustreamer # Video for Linux webcam streamer.
    v4l-utils # Video For Linux webcam utilities.
    vlc

    #
    # Audio plugins
    #

    calf
    libbs2b
    libsamplerate
    libsndfile
    lsp-plugins
    mda_lv2
    speexdsp
    tbb

    #
    # Development
    #

    # General
    cloudflared # CLI for CLoudflare tunnels.
    gcc
    wrangler # CLI for Cloudflare workers.
    tree-sitter # Syntax parser. Requires GCC or another C/C++ compiler.

    # Editors
    kate

    # Spelling
    nodePackages.cspell
    codespell

    # Writing
    glow
    nodePackages.alex
    nodePackages.write-good
    proselint
    vale

    # Git
    bfg-repo-cleaner

    # Workflows
    actionlint

    # Nix
    nixfmt # Opinionated formatter, used by `null-ls`.
    statix # Static analysis, used by `null-ls`.

    # Rust
    rust-bin.stable.latest.default # Added with Rust overlay.

    # Go
    gofumpt

    # Lua
    lua53Packages.ldoc
    luajit
    stylua

    # Python
    pythonWithPackages

    # Shell
    shellcheck
    shfmt
    shellharden
    binutils

    # JS/TS/JSON
    nodePackages.eslint_d
    nodePackages.fixjson

    # Build 
    gnumake

    # APIs and testing 
    curlie
    httpie

    # GUI
    gnome.zenity
    yad

    #
    # Appearance
    #

    # Fonts (PragmataPro Mono with ligatures in terminal and any code, commercial license)
    corefonts
    font-manager
    joypixels
    merriweather
    merriweather-sans
    paratype-pt-mono
    paratype-pt-sans
    paratype-pt-serif
    powerline-fonts
    public-sans
    redhat-official-fonts
    twemoji-color-font

    # Theming.
    catppuccin-kvantum
    d-spy
    dfeet
    gnome.dconf-editor
    gnome.gnome-themes-extra
    gsettings-desktop-schemas
    gtk3 # Needed for the gsettings script to add its schema path.
    gtk-engine-murrine
    icoutils
  ];

  #
  # GTK
  #

  gtk = let
    bookmarks = [
      "file:///home/dnordstrom/Code Code"
      "file:///home/dnordstrom/Backup Backup"
      "file:///home/dnordstrom/Pictures/screensnaps Screensnaps"
      "file:///home/dnordstrom/Videos/screencasts Screencasts"
      "file:///home/dnordstrom/Secrets Secrets"
      "file:///home/dnordstrom/.config home  me  .config"
      "file:///home/dnordstrom/.local/bin home  me  .local  bin"
      "file:///home/dnordstrom/.local/share home  me  .local  share"
      "file:///etc/nixos etc  nixos"
      "file:///etc/nixos/config etc  nixos  config"
      "file:///etc/nixos/config/firefox etc  nixos  config  firefox"
      "file:///etc/nixos/config/kitty etc  nixos  config  kitty"
      "file:///etc/nixos/config/nvim etc  nixos  config  nvim"
    ];
  in {
    enable = true;

    font = {
      name = "PT Sans";
      size = 9;
    };

    theme = customGtkTheme;
    iconTheme = customIconTheme;
    cursorTheme = customCursorTheme;

    gtk3.bookmarks = bookmarks;
  };

  ##
  # CONFIGURATION FILES
  #
  # Most configuration files are stored in their normal format and here symlinked into ~/.config or
  # wherever appropriate, even for software like Sway WM which can be configured via Home Manager.
  #
  # This is for portability reasons to make the files easier to both share with others and work on.
  # For example, this makes it simple to copy and paste defaults or snippets from online sources,
  # and the files remain useful for those not using NixOS or Home Manager.
  ##

  #
  # Scripts and shell
  #

  home.file.".local/bin/scripts".source = mkSymlink (mkBuildPath "scripts");
  home.file.".config/zsh/.zshinit".source =
    mkSymlink (mkConfigPath "zsh/zshrc");

  #
  # Wallpapers
  #

  home.file."Pictures/wallpapers".source = mkSymlink (mkBuildPath "wallpapers");

  #
  # Dolphin file manager "places"
  #

  home.file.".config/dolphin/user-places.xbel".source =
    mkSymlink (mkConfigPath "dolphin/user-places.xbel");

  #
  # Easyeffects
  #
  #   Settings directories are writable but presets directory read-only. This allows EasyEffects
  #   to modify its settings while the presets are immutable since that's where the important
  #   presets are saved.
  #
  #   Also see `services.easyeffects` for background service.
  #

  home.file.".config/easyeffects/output".source =
    mkSymlink (mkConfigPath "easyeffects/output");
  home.file.".config/easyeffects/input".source =
    mkSymlink (mkConfigPath "easyeffects/input");
  home.file.".config/easyeffects/autoload".source =
    mkSymlink (mkConfigPath "easyeffects/autoload");
  home.file.".config/easyeffects/irs".source =
    mkSymlink (mkConfigPath "easyeffects/irs");

  # Keep presets immutable so we don't fuck anything up. Not that we would, but still.
  xdg.configFile."easyeffects/presets".source = ../config/easyeffects/presets;

  #
  # River
  #

  home.file.".config/river".source = mkSymlink (mkConfigPath "river");

  # 
  # Swappy 
  #

  xdg.configFile."swappy/config".source = ../config/swappy/config;

  #
  # Bat 
  #

  xdg.configFile."bat/themes".source = ../config/bat/themes;

  #
  # Kitty
  #

  home.file.".config/kitty/config.conf".source =
    mkSymlink (mkConfigPath "kitty/config.conf");
  home.file.".config/kitty/open-actions.conf".source =
    mkSymlink (mkConfigPath "kitty/open-actions.conf");
  home.file.".config/kitty/themes".source =
    mkSymlink (mkConfigPath "kitty/themes");
  home.file.".config/kitty/sessions".source =
    mkSymlink (mkConfigPath "kitty/sessions");
  home.file.".config/kitty/kittens".source =
    mkSymlink (mkConfigPath "kitty/kittens");

  #
  # Starship
  #

  xdg.configFile."starship.toml".source = ../config/starship/starship.toml;

  #
  # Zathura
  #

  xdg.configFile."zathura".source = ../config/zathura;

  #
  # Firefox
  #

  home.file.".config/tridactyl".source =
    mkSymlink (mkConfigPath "firefox/tridactyl");

  home.file.".mozilla/native-messaging-hosts/tridactyl.json".source =
    "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";

  #
  # Neovim
  #

  home.file.".config/nvim/lua".source = mkSymlink (mkConfigPath "nvim/lua");
  home.file.".config/nvim/ftplugin".source =
    mkSymlink (mkConfigPath "nvim/ftplugin");
  home.file.".config/nvim/luasnippets".source =
    mkSymlink (mkConfigPath "nvim/luasnippets");
  home.file.".config/nvim/spell".source = mkSymlink (mkConfigPath "nvim/spell");

  #
  # Pipewire
  #

  home.file.".config/pipewire".source = mkSymlink (mkConfigPath "pipewire");
  home.file.".config/wireplumber".source =
    mkSymlink (mkConfigPath "wireplumber");

  #
  # Vifm
  #

  home.file.".config/vifm".source = mkSymlink (mkConfigPath "vifm");

  #
  # Glow
  #

  home.file.".config/glow".source = mkSymlink (mkConfigPath "glow");

  #
  # Lsd
  #

  home.file.".config/lsd".source = mkSymlink (mkConfigPath "lsd");

  #
  # Wofi
  #

  home.file.".config/wofi".source = mkSymlink (mkConfigPath "wofi");

  ##
  # PROGRAMS
  ##

  programs = {
    kodi = let
      # Metadata directory to use instead of `~/.kodi`.
      kodiDirectory = "${config.xdg.dataHome}/kodi";

      # Kodi package to use (Wayland support and added packages).
      kodiWithPackages =
        pkgs.kodi-wayland.withPackages (exts: [ exts.pvr-iptvsimple ]);
    in {
      enable = false; # Currently not using Kodi.
      datadir = kodiDirectory;
      package = kodiWithPackages;
      sources = {
        video = {
          default = "Videos";
          source = [
            {
              name = "Downloads";
              path = "${config.home.homeDirectory}/Downloads";
              allowsharing = "true";
            }
            {
              name = "Videos";
              path = "${config.home.homeDirectory}/Videos";
              allowsharing = "true";
            }
            {
              name = "Photos";
              path = "${config.home.homeDirectory}/Pictures";
              allowsharing = "true";
            }
          ];
        };
      };
    };

    mpv = {
      enable = true;
      config = {
        profile = "gpu-hq";
        force-window = true;
        ytdl-format = "bestvideo+bestaudio";
      };
    };

    zathura.enable = true;
    exa.enable = true;
    jq.enable = true;
    lsd.enable = true;
    java.enable = false; # Only used in case of emergencies.

    # Widget framework used to design top bar.
    eww = {
      enable = true;
      configDir = mkSymlink (mkConfigPath "eww");
      package = pkgs.eww-wayland;
    };

    # Customizable shell prompt written in Rust.
    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    # Gives examples of command usage.
    tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = false;
          use_pager = true;
        };
        updates.auto_update = true;
      };
    };

    # Snippet manager.
    pet = {
      enable = true;
      snippets = [{
        description = "Copy Firefox password from Bitwarden";
        command =
          "bw get item Firefox | jq -r '.login.password // empty' | wl-copy";
        tag = [ "password" "copy" "clipboard" "json" ];
      }];
    };

    # Fox on fire.
    firefox = let
      # Defaults preferences for all Firefox profiles.
      config = {
        # Disable annoyances.
        "browser.aboutConfig.showWarning" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "extensions.webextensions.restrictedDomains" = "";

        # Enable userChrome.css and `userContent.css`.
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Enable compact mode option.
        "browser.compactmode.show" = true;

        # Enable legacy screen share indicator (better for Wayland).
        "privacy.webrtc.legacyGlobalIndicator" = false;

        # Enable certain key combinations for Tridactyl add-on.
        "privacy.resistFingerprinting" = false;
        "privacy.resistFingerprinting.block_mozAddonManager" = false;
      };
    in {
      enable = true;
      package = inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin;
      profiles = {
        default = {
          id = 0;
          name = "Default";
          settings = config;
        };
        private = {
          id = 1;
          name = "Private";
          settings = config;
        };
        testing = {
          id = 2;
          name = "Testing";
          settings = config;
        };
        music = {
          id = 3;
          name = "Music";
          settings = config;
        };
      };
    };

    chromium = { enable = true; };

    kitty = {
      enable = true;
      extraConfig = "include ./config.conf";
    };

    # Configure Git to use the email privacy feature in GitHub.
    git = {
      enable = true;
      userName = "dnordstrom";
      userEmail = "dnordstrom@users.noreply.github.com";
      aliases = {
        # Commit using editor for commit message. Edit `.git/hooks/prepare-commit-msg.sample` and
        # `.git/hooks/commit-msg.sample`, and remove the ".sample" suffix to set message defaults.
        c = "commit --all --edit";

        # Show repostitory status, e.g. untracked files and changes since last commit.
        s = "status";

        # Check out branch, creating it if needed.
        b = "switch -c";

        # Show log in readable format, abbreviating hashes and showing one-line commits.
        l = "log --pretty=oneline -expand-tabs=2";
      };

      # TODO: Include GPG/SSH key.
      # signing.signByDefault = true;
    };

    neovim = {
      package = pkgs.neovim-nightly;
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraConfig = "lua require('init')"; # Only line needed, loads Lua config.
    };

    zsh = {
      autocd = true;
      enable = true;
      syntaxHighlighting.enable = true;
      enableVteIntegration = true;
      enableAutosuggestions = true;

      # Add completion for system packages such as `systemd`:
      #
      # NOTE:
      #   * Requires this option to get completion of arguments for system packages like `systemd`:  
      #     `environment.pathsToLink = [ "/share/zsh" ];`
      #
      # We've added it in `./modules/common.nix`
      enableCompletion = true;

      cdpath = [ buildDirectory homeDirectory "${homeDirectory}/Code" ];
      dotDir = ".config/zsh";
      history.path = "${config.xdg.dataHome}/zsh/history";

      # Plugins installed either here with Git or from nixpkgs if available, using the build in plugin
      # management, meaning we need to point it to the correct file to load, usually ending in
      # ".plugin.zsh" abd then gets automatically detected by NixOS. Otherwise the `file` attribute
      # tells it where to load it from.
      plugins = [
        {
          name = "zsh-vi-mode";
          src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
        }
        {
          name = "fzf-tab";
          src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
        }
        {
          name = "nix-shell";
          src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
        }
        {
          name = "autopair";
          file = "autopair.zsh";
          src = "${pkgs.zsh-autopair}/share/zsh/zsh-autopair";
        }
        {
          name = "zsh-abbrev-alias";
          file = "abbrev-alias.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "momo-lab";
            repo = "zsh-abbrev-alias";
            rev = "33fe094da0a70e279e1cc5376a3d7cb7a5343df5";
            sha256 = "sha256-jq5YEpIpvmBa/M7F4NeC77mE9WHSnza3tZwvgMPab7M=";
          };
        }
        {
          name = "doas";
          file = "doas.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "Senderman";
            repo = "doas-zsh-plugin";
            rev = "f5c58a34df2f8e934b52b4b921a618b76aff96ba";
            sha256 = "sha256-136DzYG4v/TuCeJatqS6l7qr7bItEJxENozpUGedJ9o=";
          };
        }
      ];

      # Source the user's private config that we symlink to `~/.config/zsh/.zshinit`. In real life,
      # it's located at `/etc/nixos/config/zsh/zshrc` but renamed since `~/.config/zsh/zshrc` is
      # generated automatically. This adds lines to the bottom of it.
      initExtra = "source ${homeDirectory}/.config/zsh/.zshinit";
    };

    # Smarter `cd`.
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # Smarter `cat`.
    bat = {
      enable = true;
      config = {
        color = "always";
        italic-text = "always";
        tabs = "2";
        theme = "Catppuccin-latte";
        style = "header-filename,header-filesize,rule,numbers,changes";
      };
    };

    # Smarter finder and menu.
    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = false;
      enableBashIntegration = false;
    };

    # Actually Go.
    go = {
      enable = true;
      goPath = "${homeDirectory}/.local/bin/go"; # Using `~/go` is lunacy.
    };

    # Automate when entering a directory, e.g. load isolated development shells automatically with
    # all dependencies available without global installs. Just `direnv` alone works, but enabling
    # `nix-direnv` caches dependencies.
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # TUI feed reader.
    newsboat = {
      enable = true;
      autoReload = true;
      extraConfig = ''
        #
        # Newsboat configuration
        #
        # Based on:
        #   - https://github.com/meribold/dotfiles
        #   - https://github.com/rememberYou/dotfiles
        #

        #
        # GENERAL
        #

        auto-reload yes
        refresh-on-startup yes
        reload-threads 16
        reload-time 15
        show-read-feeds yes
        notify-program "notify-send"
        notify-format "Feeds refreshed (%d new)"
        text-width 72
        download-full-page yes
        browser "rdrview -B 'lynx -display-charset=utf8 -dump' '%u' | less"

        #
        # MACROS
        #

        # ,m -> Open with mpv
        macro m set browser "mpv %u" ; open-in-browser ; set browser "rdrview -B 'lynx -display-charset=utf8 -dump' '%u' | less"

        # ,o -> Open with default
        macro o set browser "xdg-open '%u'" ; open-in-browser ; set browser "rdrview -B 'lynx -display-charset=utf8 -dump' '%u' | less"

        #
        # UNMAP DANGEROUS DEFAULTS
        #

        # mark-all-feeds-read
        unbind-key C

        # delete-all-articles
        unbind-key ^D

        # delete-article
        unbind-key D

        #
        # KEY BINDS
        #

        bind-key @ macro-prefix
        bind-key ^X delete-article
        bind-key ; cmdline
        bind-key SPACE next-unread
        bind-key j down
        bind-key k up
        bind-key J next-feed articlelist
        bind-key K prev-feed articlelist
        bind-key ^N next-unread
        bind-key ^P prev-unread
        bind-key ^N next-unread-feed articlelist
        bind-key ^P prev-unread-feed articlelist
        bind-key ] next feedlist
        bind-key [ prev feedlist
        bind-key ] next-feed articlelist
        bind-key [ prev-feed articlelist
        bind-key g home
        bind-key G end
        bind-key ^U pageup
        bind-key ^D pagedown
        bind-key u pageup
        bind-key d pagedown

        #
        # COLORS
        #

        color background        default  default
        color info              color232 color3   bold
        color listnormal        default  default
        color listnormal_unread default  default  bold
        color listfocus         color232 blue
        color listfocus_unread  color232 blue     bold
        color article           default  default
      '';
      urls = [
        {
          title = "Updates";
          tags = [ "newsboat" ];
          url = "https://newsboat.org/news.atom";
        }
        {
          # All Pocket articles.
          title = "Pocket";
          tags = [ "pocket" ];
          url = "https://getpocket.com/users/dnordstrom/feed/all";
        }
        {
          # Unread Pocket articles.
          title = "Pocket Unread";
          tags = [ "pocket" ];
          url = "https://getpocket.com/users/dnordstrom/feed/unread";
        }
      ];
    };

    # Encrypts and signs things. Good if it's mutable so it's usable.
    gpg = {
      enable = true;
      mutableKeys = true;
      mutableTrust = true;
    };
  };

  ##
  # MANUAL
  ##

  manual = {
    html.enable = true; # Adds `home-manager-help` tool.
    json.enable = true; # Adds `<profile>/share/doc/home-manager/options.json`.
  };

  ##
  # SERVICES
  ##

  #
  # Modules
  #

  services = {
    # Notification daemon
    mako = {
      actions = true;
      backgroundColor = "#B7E5E6";
      borderColor = "#6E6C7E";
      borderRadius = 0;
      defaultTimeout = 5000;
      enable = true;
      icons = true;
      maxIconSize = 48;
      iconPath =
        "${customIconTheme.package}/share/icons/${customIconTheme.name}";
      font = "PT Sans 9";
      margin = "12";
      markup = true;
      padding = "12,24";
      textColor = "#1E1E28";
      width = 325;
    };

    # Monitor layouts.
    kanshi = let
      # Primary [center]: 35" 1440p @ 100Hz
      benq-1 = {
        mode = "3440x1440@99.982Hz";
        position = "2397,780";
        scale = 1.0;
      };
      # Secondary [bottom left]: 24" 1080p @ 144Hz & Downscaled
      aoc-1 = {
        mode = "1920x1080@144.001Hz";
        position = "0,1349";
        scale = 0.8;
      };
      # Tertiary [top left]: 24" 1080p @ 60Hz & Downscaled
      aoc-2 = {
        mode = "1920x1080@60Hz";
        position = "0,0";
        scale = 0.8;
      };
    in {
      enable = true;
      systemdTarget = "river-session.target";
      profiles = {
        # Home: DisplayPort for primary monitor.
        home = {
          outputs = [
            {
              criteria = "DP-1";
              status = "enable";
              mode = benq-1.mode;
              position = benq-1.position;
              scale = benq-1.scale;
            }
            {
              criteria = "DP-2";
              status = "enable";
              mode = aoc-1.mode;
              position = aoc-1.position;
              scale = aoc-1.scale;
            }
            {
              criteria = "DVI-D-1";
              status = "enable";
              mode = aoc-2.mode;
              position = aoc-2.position;
              scale = aoc-2.scale;
            }
          ];
        };
      };
    };

    # I don't want it, but Gnome keyring is required by certain software.
    gnome-keyring.enable = true;

    # Asks for GPG password when needed. About once every 3 minutes.
    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      pinentryFlavor = "qt";
    };

    # Gradually adjusts monitor color temperature at sunset and sunrise.
    gammastep = {
      enable = true;
      tray = false;

      temperature = {
        day = 6500;
        night = 4500;
      };

      latitude = 62.38;
      longitude = 17.32;
    };
  };

  #
  # SYSTEMD
  #

  # EWW daemon for widgets like the top bar.
  systemd.user = {
    services = {
      eww = {
        Unit = {
          Description = "EWW configured for River.";
          Documentation = "https://github.com/elkowar/eww";
          PartOf = [ "river-session.target" ];
          After = [ "river-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.eww-wayland}/bin/eww open --restart top-bar";
          ExecReload = "${pkgs.eww-wayland}/bin/eww open --restart top-bar";
          Restart = "on-failure";
          KillMode = "mixed";
        };
        Install.WantedBy = [ "river-session.target" ];
      };
    };

    # Target triggered when River WM has been launched.
    targets = {
      river-session = {
        Unit = {
          Description = "River compositor session";
          Documentation = [ "man:systemd.special(7)" ];
          BindsTo = [ "graphical-session.target" ];
          Wants = [ "graphical-session-pre.target" ];
          After = [ "graphical-session-pre.target" ];
        };
      };
    };
  };

  ##
  # SECURITY
  ##

  pam.yubico.authorizedYubiKeys.ids = [ "ccccccurnfle" "cccccclkvllh" ];
}

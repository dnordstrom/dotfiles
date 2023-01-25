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

  # Username to use for paths.
  username = "dnordstrom";

  # Path of NixOS build configuration.
  buildDirectory = "/etc/nixos";

  # Home directory of user.
  homeDirectory = "/home/${username}";

  # Utility shortcuts.
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
  mkConfigRootPath = path: /. + "${buildDirectory}/${path}";

  # Convenience method to convert relative path to absolute, based on the user's home directory.
  #
  # @param {string|path} path - Relative input.
  # @returns {path} path - Absolute output.
  mkHomePath = path: /. + "${homeDirectory}/${path}";

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
  xdgEditor = [ "neovim-kitty.desktop" ];
  xdgFileBrowser = [ "org.kde.dolphin.desktop" ];
  xdgHttpie = [ "httpie-appimage.desktop" ];
  xdgImageViewer = [ "vimiv.desktop" ];
  xdgMailClient = [ "firefox.desktop" ];
  xdgMarkdown = [ "neovim-kitty.desktop" ];
  xdgMediaPlayer = [ "org.kde.haruna.desktop" ];
  xdgMoneroWallet = [ "mymonero-appimage.desktop" ];
  xdgPasswordManager = [ "bitwarden-appimage.desktop" ];
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

  python-packages = ps: with ps; [ i3ipc requests ];
  python-with-packages = pkgs.python3.withPackages python-packages;

  #
  # GSETTINGS
  #
  # TODO: Make it work.
  #

  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schemas = pkgs.gsettings-desktop-schemas;
      datadir = "${schemas}/share/gsettings-schemas/${schemas.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS

      gnome_schema="org.gnome.desktop.interface"
      gsettings set $gnome_schema gtk-theme "Catppuccin-Latte-Peach"
    '';
  };
in rec {
  ##
  # ENVIRONMENT
  ##

  home = {
    stateVersion = "23.05";

    sessionVariables = {
      EDITOR = editor;
      BROWSER = browser;
      TERMINAL = terminal;
    };

    sessionPath = [ "${homeDirectory}/.local/bin" ];
  };

  ##
  # XDG ENTRIES AND ASSOCIATIONS
  ##

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = mimeAassociations;
      defaultApplications = mimeAassociations;
    };

    desktopEntries = let
      # Firefox Nightly desktop files for different profiles are geberated based on this.
      firefoxName = "Firefox Nightly";
      firefoxGenericName = "Web Browser";
      firefoxType = "Application";
      firefoxIcon = "firefox-dev";
      firefoxCategories = [ "Network" "WebBrowser" ];
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
    in {
      #
      # Desktop applications
      #

      nemo-without-cinnamon = {
        name = "Nemo (Non-DE)";
        comment = "Nemo without Cinnamon";
        type = "Application";
        genericName = "Access and organize files";
        exec = "nemo %U";
        terminal = false;
        icon = "system-file-manager";
        categories = [ "GNOME" "GTK" "Utility" "Core" ];
        mimeType = [ "inode/directory" "application/x-gnome-saved-search" ];
        startupNotify = false;
      };

      httpie-appimage = {
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

      ferdium-appimage = {
        name = "Ferdium";
        type = "Application";
        genericName =
          "Messaging app for WhatsApp, Slack, Telegram, Gmail, Hangouts and many many more.";
        exec =
          "appimage-run ${homeDirectory}/.local/bin/ferdium/ferdium.appimage";
        terminal = false;
        icon = "ferdium";
        categories = [ "Network" "InstantMessaging" ];
        mimeType = [ ];
        startupNotify = false;
      };

      session-appimage = {
        name = "Session";
        type = "Application";
        genericName = "Private messaging from your desktop";
        exec =
          "appimage-run ${homeDirectory}/.local/bin/session/session.appimage";
        terminal = false;
        icon = "session-desktop";
        categories = [ "Network" ];
        mimeType = [ ];
        startupNotify = false;
        settings = { StartupWMClass = "session"; };
      };

      station-appimage = {
        name = "Station";
        type = "Application";
        genericName = "Web service manager";
        exec =
          "GDK_BACKEND=x11 appimage-run ${homeDirectory}/.local/bin/station/station.appimage";
        terminal = false;
        icon = "station-desktop-app";
        categories = [ "Network" ];
        mimeType = [ "x-scheme-handler/station" ];
        startupNotify = false;
        settings = { StartupWMClass = "Station"; };
      };

      mymonero-appimage = {
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

      singlebox-appimage = {
        name = "Singlebox";
        type = "Application";
        genericName = "All-in-One Messenger";
        exec =
          "appimage-run ${homeDirectory}/.local/bin/singlebox/singlebox.appimage -- %U";
        terminal = false;
        icon = "singlebox";
        categories = [ "Utility" ];
        mimeType = [
          "x-scheme-handler/https"
          "x-scheme-handler/http"
          "x-scheme-handler/mailto"
          "x-scheme-handler/webcal"
        ];
        startupNotify = false;
      };

      bitwarden-appimage = {
        name = "Bitwarden (AppImage)";
        type = "Application";
        genericName = "Password Manager";
        exec =
          "appimage-run ${homeDirectory}/.local/bin/bitwarden/bitwarden.appimage %U";
        terminal = false;
        icon = "ferdium";
        categories = [ "Utility" ];
        mimeType = [ "x-scheme-handler/bitwarden" ];
        startupNotify = false;
        settings = { StartupWMClass = "Bitwarden"; };
      };

      #
      # COMMAND LINE APPLICATIONS
      #

      neovim-kitty = {
        name = "Neovim (kitty)";
        type = "Application";
        genericName = "Text Editor";
        exec = "kitty --title popupterm -e nvim %F";
        terminal = false;
        icon = "nvim";
        categories = [ "Utility" "TextEditor" "Development" "IDE" ];
        mimeType = [ "text/plain" "inode/directory" ];
        startupNotify = false;
      };

      vifm-kitty = {
        name = "Vifm (kitty)";
        type = "Application";
        genericName = "File Manager";
        exec = "kitty --title popupterm -e vifm %F";
        terminal = false;
        icon = "vifm";
        categories = [ "System" "FileManager" ];
        mimeType = [ "text/plain" "inode/directory" ];
        startupNotify = false;
      };

      glow-kitty = {
        name = "Glow (kitty)";
        type = "Application";
        genericName = "Markdown Viewer";
        exec = "kitty --title popupterm -e glow %F";
        terminal = false;
        icon = "kitty";
        categories = [ "Utility" "TextEditor" ];
        mimeType = [ "text/markdown" ];
        startupNotify = false;
      };

      #
      # STARTUP SESSIONS
      #

      kitty-session-wpo = {
        name = "WPO development (kitty)";
        comment = "WPO development (kitty)";
        type = "Application";
        genericName = "Text Editor";
        exec = ''
          kitty --session "${buildDirectory}/config/kitty/sessions/dev-cloud.session" --single-instance --instance-group dev-wpo
        '';
        terminal = false;
        icon = "kitty";
        categories = [ "Utility" "TextEditor" "Development" "IDE" ];
        mimeType = [ "text/plain" "inode/directory" ];
        startupNotify = true;
      };

      kitty-session-cloud = {
        name = "Cloud development (kitty)";
        comment = "Cloud development (kitty)";
        type = "Application";
        genericName = "Text Editor";
        exec = ''
          kitty --session "${buildDirectory}/config/kitty/sessions/dev-cloud.session" --single-instance --instance-group dev-cloud
        '';
        terminal = false;
        icon = "kitty";
        categories = [ "Utility" "TextEditor" "Development" "IDE" ];
        mimeType = [ "text/plain" "inode/directory" ];
        startupNotify = true;
      };

      kitty-session-scratch = {
        name = "Scratchpad terminal (kitty)";
        comment = "Scratchpad terminal (kitty)";
        type = "Application";
        genericName = "Text Editor";
        exec = ''
          kitty --class scratchterm --name scratchterm --session "${buildDirectory}/config/kitty/sessions/scratchpad.session" --single-instance --instance-group scratch
        '';
        terminal = false;
        icon = "kitty";
        categories = [ "Utility" "TextEditor" "Development" "IDE" ];
        mimeType = [ "text/plain" "inode/directory" ];
        startupNotify = true;
      };

      #
      # Browser profiles
      #

      firefoxDefault = {
        name = "${firefoxName} (Default)";
        type = firefoxType;
        genericName = firefoxGenericName;
        exec = "firefox -P Default %U";
        terminal = false;
        icon = firefoxIcon;
        categories = firefoxCategories;
        mimeType = firefoxMimeType;
        startupNotify = false;
        settings = { StartupWMClass = "firefox-nightly-default"; };
      };

      firefoxPrivate = {
        name = "${firefoxName} (Private)";
        type = firefoxType;
        genericName = firefoxGenericName;
        exec = "firefox -P Private %U";
        terminal = false;
        icon = firefoxIcon;
        categories = firefoxCategories;
        mimeType = firefoxMimeType;
        startupNotify = false;
        settings = { StartupWMClass = "firefox-nightly-private"; };
      };

      firefoxTesting = {
        name = "${firefoxName} (Testing)";
        type = firefoxType;
        genericName = firefoxGenericName;
        exec = "firefox -P Testing %U";
        terminal = false;
        icon = firefoxIcon;
        categories = firefoxCategories;
        mimeType = firefoxMimeType;
        startupNotify = false;
        settings = { StartupWMClass = "firefox-nightly-testing"; };
      };

      firefoxMusic = {
        name = "${firefoxName} (Music)";
        type = firefoxType;
        genericName = firefoxGenericName;
        exec = "firefox -P Music %U";
        terminal = false;
        icon = firefoxIcon;
        categories = firefoxCategories;
        mimeType = firefoxMimeType;
        startupNotify = false;
        settings = { StartupWMClass = "firefox-nightly-music"; };
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

    nordpkgs.convox
    nordpkgs.lswt

    #
    # Networking
    #

    gnunet
    gnunet-gtk
    onionshare-gui
    qbittorrent
    rofi-bluetooth
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
    # Programs, packages, and files
    #

    appimage-run
    cinnamon.nemo
    dolphin
    ffmpegthumbnailer
    fsearch
    gnome.nautilus
    nvme-cli

    #
    # Feeds
    #
    # RSS feeds, Atom feeds, and occasionally web scraping appear to decrease in popularity. We
    # produce more content than ever, but content discovery and digestion become fragmented. We
    # have blog platforms that charge their readers, we have Medium which is just 
    #

    gnome-podcasts
    libsForQt5.kasts
    pocket-casts
    raven-reader

    #
    # Communication
    #

    element-desktop
    fractal
    gomuks
    gotktrix
    mirage-im
    nheko
    qtox
    schildichat-desktop-wayland
    signal-desktop
    slack
    slack-term
    utox
    weechat

    #
    # Command line
    #

    awscli2
    bottom
    fd
    gh
    libnotify
    librsvg # Sypposedly a dependency to mdcat for showing images.
    mdcat
    ncpamixer # TRY: We ready to let Pavucontrol go?
    neofetch
    onefetch
    pamixer # TRY: ^ See previous question.
    parallel
    rdrview
    ripgrep
    enlightenment.terminology
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

    cliphist
    clipman
    flameshot
    gebaar-libinput
    grim
    imagemagick
    libinput
    libinput-gestures
    lisgd
    river
    rofi-calc
    rofi-emoji
    rofi-systemd
    rofi-wayland
    slurp
    swappy
    swaybg
    swayidle
    swaylock-effects
    swayr
    swaywsr
    vimiv-qt
    wdisplays
    wev
    wf-recorder
    wl-clipboard
    wlopm
    wofi
    wofi-emoji
    wshowkeys
    wtype
    xdg_utils # For `xdg-open`.
    xkeyboard_config
    xorg.setxkbmap
    xorg.xinput
    ydotool

    #
    # Office 
    #

    libreoffice-fresh

    #
    # Web
    #

    # See GH issue: https://github.com/NixOS/nixpkgs/issues/146401
    (tor-browser-bundle-bin.override { useHardenedMalloc = false; })
    tridactyl-native # Firefox native messaging host.

    #
    # Security
    #

    # Proton suite community CLI due to GUI/DE dependencies in the official clients.
    # TODO: Use official clients once headless works (when they release the new client.)
    # protonvpn-cli # Official CLI.
    protonvpn-gui # Official GUI.
    # protonvpn-cli_2 # Community CLI.

    _1password
    _1password-gui-beta
    bitwarden
    bitwarden-cli
    git-crypt
    gnome.gnome-keyring
    pinentry-qt
    yubico-pam
    yubico-piv-tool
    yubikey-agent
    yubikey-manager
    yubikey-manager-qt
    yubikey-personalization
    yubikey-personalization-gui
    yubikey-touch-detector

    #
    # Multimedia
    #

    alsa-firmware
    cava
    easyeffects # Systemd service (`services.easyeffects` module), but keep conflicts with JamesDSP.
    enlightenment.ephoto
    enlightenment.rage
    handbrake
    haruna
    jamesdsp
    pavucontrol
    playerctl
    pulsemixer
    streamlink
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
    cloudflared # CLI for CLoudflare tunnels
    tree-sitter

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
    python-with-packages

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
    nodePackages.node-gyp
    nodePackages.node-gyp-build

    # APIs and testing 
    insomnia
    curlie
    httpie

    #
    # Appearance
    #

    # Fonts (PragmataPro Mono with ligatures in terminal and any code, commercial license)
    corefonts
    dejavu_fonts
    fcft # Font loading library used by foot.
    font-manager
    ibm-plex
    inriafonts
    joypixels
    libertine
    merriweather
    merriweather-sans
    openmoji-black
    openmoji-color
    paratype-pt-mono
    paratype-pt-sans
    paratype-pt-serif # Current serif and print format font.
    powerline-fonts
    public-sans # Current UI font. Sometimes a custom, patched Input Sans.
    redhat-official-fonts
    source-sans
    source-serif
    twemoji-color-font
    work-sans

    # Emoji tools.
    emoji-picker # TUI picker.
    emojipick # For `rofi` and `wofi`.
    emote
    rofi-emoji
    rofimoji


    # Qt libs/apps.
    libsForQt5.ark
    libsForQt5.kdegraphics-thumbnailers
    libsForQt5.keditbookmarks
    libsForQt5.kfilemetadata
    libsForQt5.kgpg # Graphical GPG interface.
    libsForQt5.kparts
    libsForQt5.okular # Document viewer which is needed for Kate's (or Kpart's) Markdown preview.
    libsForQt5.qt5.qtgraphicaleffects # Needed by Quaternion Matrix client.
    libsForQt5.qtstyleplugin-kvantum

    # Theming.
    configure-gtk
    dfeet
    d-spy
    gnome.dconf-editor
    gsettings-desktop-schemas
    icoutils

    #
    # Interesting prospects.
    #

    input-remapper
    interception-tools # And caps2esc plugin, for intercepting at device level instead of WM.
    navi # CLI cheatsheet tool.
    ytfzf # Fzf utility for YouTube.
    kooha # Screen recorder GUI.
    fx_cast_bridge # For casting video from Firefox.
  ];

  #
  # SWAY
  #
  # We use this option for installing Sway since it adds commands to the config for systemd
  # integration. Configuration is kept in original format and symlinked (impure) from
  # `/etc/nixos/config/sway` to `~/.config/sway` to allow editing it without rebuilding NixOS.
  #
  # Home Manager creates a configuration file even if we set `config` to `null`, so we use 
  # `extraConfigEarly` to instead insert a line at the top that loads our own.
  #

  wayland.windowManager.sway = {
    enable = true;
    config = null;
    systemdIntegration =
      true; # Enables "sway-session.target" and triggers it in config file.
    extraConfigEarly = "include main.conf";
  };

  #
  # GTK
  #

  gtk = let
    config = { dark = "false"; };
    gtk3Config = { gtk-application-prefer-dark-theme = "${config.dark}"; };
    gtk2Config = ''gtk-application-prefer-dark-theme = "${config.dark}";'';
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
      name = "Public Sans";
      size = 9;
    };

    theme.name =
      "Catppuccin-Latte-Peach"; # No package, manually copied to `~/.local/share/themes`.

    iconTheme = {
      name = "Vimix";
      package = pkgs.vimix-icon-theme;
    };

    cursorTheme = {
      name = "Quintom_Snow";
      package = pkgs.quintom-cursor-theme;
    };

    gtk2.extraConfig = gtk2Config;
    gtk3.extraConfig = gtk3Config;
    gtk4.extraConfig = gtk3Config;
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
  # SCRIPTS AND SHELL
  #

  home.file.".local/bin/scripts".source =
    mkSymlink (mkConfigRootPath "scripts");
  home.file.".config/zsh/.zshinit".source =
    mkSymlink (mkConfigPath "zsh/zshrc");

  #
  # WALLPAPERS
  #

  home.file."Pictures/Wallpapers".source =
    mkSymlink (mkConfigRootPath "wallpapers");

  #
  # DOLPHIN FILE MANAGER "PLACES"
  #

  home.file.".config/dolphin/user-places.xbel".source =
    mkSymlink (mkConfigPath "dolphin/user-places.xbel");

  #
  # EASYEFFECTS
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

  # Keep EasyEffects oresets immutable so we don't fuck anything up. Not that we ever would, Still.
  xdg.configFile."easyeffects/presets".source = ../config/easyeffects/presets;

  #
  # SWAY
  #
  # We can't symlink the `~/.config/sway` directory if the Home Manager module handles the systemd
  # integration (since it adds a config file with the systemd target command), we have to symlink
  # individual files. For some reason `xdg.configFile` doesn't work so we use `home.file`.
  #

  home.file.".config/sway/start".source = mkSymlink (mkConfigPath "sway/start");
  home.file.".config/sway/main.conf".source =
    mkSymlink (mkConfigPath "sway/main.conf");
  home.file.".config/sway/colors.catppuccin.conf".source =
    mkSymlink (mkConfigPath "sway/colors.catppuccin.conf");
  home.file.".config/swaylock/config".source =
    mkSymlink (mkConfigPath "swaylock/config");
  home.file.".config/swaynag/config".source =
    mkSymlink (mkConfigPath "swaynag/config");

  #
  # RIVER
  #

  home.file.".config/river".source = mkSymlink (mkConfigPath "river");

  # 
  # SWAPPY 
  #

  xdg.configFile."swappy/config".source = ../config/swappy/config;

  #
  # BAT 
  #

  xdg.configFile."bat/themes".source = ../config/bat/themes;

  #
  # KITTY
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
  # STARSHIP
  #

  xdg.configFile."starship.toml".source = ../config/starship/starship.toml;

  #
  # ZATHURA
  #

  xdg.configFile."zathura".source = ../config/zathura;

  #
  # FIREFOX
  #

  home.file.".config/tridactyl".source =
    mkSymlink (mkConfigPath "firefox/tridactyl");

  home.file.".mozilla/native-messaging-hosts/tridactyl.json".source =
    "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";

  #
  # NEOVIM
  #

  home.file.".config/nvim/lua".source = mkSymlink (mkConfigPath "nvim/lua");
  home.file.".config/nvim/ftplugin".source =
    mkSymlink (mkConfigPath "nvim/ftplugin");
  home.file.".config/nvim/luasnippets".source =
    mkSymlink (mkConfigPath "nvim/luasnippets");
  home.file.".config/nvim/spell".source = mkSymlink (mkConfigPath "nvim/spell");

  #
  # VIFM
  #

  home.file.".config/vifm".source = mkSymlink (mkConfigPath "vifm");

  #
  # GLOW
  #

  home.file.".config/glow".source = mkSymlink (mkConfigPath "glow");

  #
  # LSD
  #

  home.file.".config/lsd".source = mkSymlink (mkConfigPath "lsd");

  #
  # WOFI
  #

  home.file.".config/wofi".source = mkSymlink (mkConfigPath "wofi");

  #
  # WAYBAR
  #

  home.file.".config/waybar".source = mkSymlink (mkConfigPath "waybar");

  ##
  # PROGRAMS
  ##

  #
  # TRYOUTS
  #

  programs.kodi = let
    # Metadata directory to use instead of `~/.kodi`.
    kodi-directory = "${config.xdg.dataHome}/kodi";

    # Kodi package to use (Wayland support and added packages).
    kodi-with-packages =
      pkgs.kodi-wayland.withPackages (exts: [ exts.pvr-iptvsimple ]);
  in {
    enable = true;
    datadir = kodi-directory;
    package = kodi-with-packages;
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

  #
  # UTILITIES
  #

  programs.exa.enable = true;
  programs.jq.enable = true;
  programs.lsd.enable = true;

  #
  # MEDIA
  #

  programs.mpv.enable = true;

  #
  # OFFICE
  #
  # "Word processing" and "desktop publishing" if like me you are considered a wise elderly among
  # peers. Signs include people looking up to you in increasingly looking-down-at-you ways; people 
  # communicating as if you're either not in the room or your age is either one digit or three.
  #
  # This software is for communicating with other fossils wanting to speed up the process. Also, our
  # prototype HUMP (Household UMP) now KO's any Gates-chip within 30ft and keeps intact Gates-OS,
  # Gates-software, what *actually* tracks your ass. For that, you want Norton Antivirus and Jesus.
  #

  # PDF viewer.
  programs.zathura.enable = true;

  #
  # DEVELOPMENT
  #

  # Necessary evil.
  programs.java.enable = true;

  # Status bar we use in Sway WM.
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target =
        "sway-session.target"; # Default is `graphical-session.target`, but we only use it in Sway.
    };
  };

  # Status bar we use in River WM.
  programs.eww = {
    enable = true;
    configDir = mkSymlink (mkConfigPath "eww");
    package = pkgs.eww-wayland;
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  # Customizable shell prompt written in Rust.
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # Gives examples of command usage.
  programs.tealdeer = {
    enable = true;
    settings = {
      display = {
        compact = false;
        use_pager = true;
      };
      updates.auto_update = false;
    };
  };

  # Command line snippets manager.
  programs.pet = {
    enable = true;
    snippets = [{
      description = "Copy Firefox password";
      command =
        "bw get item Firefox | jq -r '.login.password // empty' | wl-copy";
      tag = [ "password" "copy" "clipboard" "json" ];
    }];
  };

  # Fox on fire.
  programs.firefox = let
    config = {
      # Disable annoyances
      "browser.aboutConfig.showWarning" = false;
      "browser.shell.checkDefaultBrowser" = false;
      "browser.bookmarks.restore_default_bookmarks" = false;
      "extensions.webextensions.restrictedDomains" = "";

      # Enable userChrome.css and `userContent.css`.
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

      # Enable showing compact mode option.
      "browser.compactmode.show" = true;

      # Enable legacy screen share indicator that works better in Wayland.
      "privacy.webrtc.legacyGlobalIndicator" = false;

      # Needed to make certain key combinations work with Tridactyl.
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

  programs.chromium = {
    enable = true;
    extensions = [{
      id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; # 1Password
    }];
  };

  programs.kitty = {
    enable = true;
    extraConfig = "include ./config.conf";
  };

  programs.git = {
    enable = true;
    userName = "dnordstrom";
    userEmail = "d@mrnordstrom.com";
    aliases = {
      # Opens editor with commit message temnplate.
      save = "commit --all --edit";

      # Show repostitory status, e.g. untracked files and changes since last commit.
      stat = "status";

      # Checks out branch if it exiss, otherwise create it first.
      swap = "switch -c";

      # Show commit history 
      list = "log --oneline";
    };

    # TODO: Need to include the key before this works.
    # signing.signByDefault = true;
  };

  programs.neovim = {
    package = pkgs.neovim-unwrapped; # Uses nightly flake.
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = "lua require('init')";
  };

  programs.zsh = {
    autocd = true;
    enable = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;
    enableAutosuggestions = true;

    # We'll add completion for system packages such as `systemd`:
    #
    # NOTES:
    #   * Requires this option to get completion of arguments for system packages like `systemd`:  
    #     `environment.pathsToLink = [ "/share/zsh" ];`
    enableCompletion = true;

    dotDir = ".config/zsh";
    history.path = "${config.xdg.dataHome}/zsh/history";

    cdpath = [
      buildDirectory
      homeDirectory
      "${homeDirectory}/Code"
      "${homeDirectory}/.local"
      "${homeDirectory}/.config"
    ];

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

    # Source our config from `~/.config/zsh/.zshinit` which is a symlink to `${buildDirectory}/config/zsh/zshrc`.
    initExtra = "source ${homeDirectory}/.config/zsh/.zshinit";
  };

  # Smarter `cd`.
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Cat with wings.
  programs.bat = {
    enable = true;
    config = {
      color = "always";
      italic-text = "always";
      tabs = "2";
      theme = "Catppuccin-latte";
      style = "header-filename,header-filesize,rule,numbers,changes";
    };
  };

  # Fuzzy finder written in Go.
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = false;
    enableBashIntegration = false;
  };

  # Actually Go.
  programs.go = {
    enable = true;
    goPath = "${config.home.homeDirectory}/.local/bin/go"; # Don't use `~/go`...
  };

  # Do things when entering a directory. Used to load isolated development shells automatically.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # Improves caching of Nix devshells.
  };

  # Notification daemon.
  programs.mako = {
    actions = true;
    backgroundColor = "#B7E5E6";
    borderColor = "#6E6C7E";
    borderRadius = 0;
    defaultTimeout = 5000;
    enable = true;
    icons = true;
    maxIconSize = 48;
    iconPath = "${pkgs.vimix-icon-theme}/share/icons/Vimix";
    font = "Public Sans 8";
    margin = "12";
    markup = true;
    padding = "12,24";
    textColor = "#1E1E28";
    width = 325;
  };

  # TUI RSS reader.
  programs.newsboat = {
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
        title = "Pocket";
        tags = [ "pocket" ];
        url = "https://getpocket.com/users/dnordstrom/feed/all";
      }
      {
        title = "Pocket Unread";
        tags = [ "pocket" ];
        url = "https://getpocket.com/users/dnordstrom/feed/unread";
      }
    ];
  };

  # Encrypts and signs things.
  programs.gpg = {
    enable = true;
    mutableKeys = true;
    mutableTrust = true;
    # settings = '''';
  };

  ##
  # MANUAL
  ##

  manual = {
    # Installs `home-manager-help` tool.
    html.enable = true;

    # Installs to `<profile>/share/doc/home-manager/options.json`.
    json.enable = true;
  };

  ##
  # SERVICES
  ##

  #
  # MODULES
  #

  services = {
    #
    # Monitor layouts
    #
    # Based on the original config at `config/kanshi/config` for reference and portability. This
    # service does not make `kanshictl` or `kanshi` available to the user. Adding `kanshi` to the
    # package list for that if needed.
    #
    kanshi = {
      enable = true;
      systemdTarget = "river-session.target";
      profiles = {
        home = {
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
              scale = 0.8;
              status = "enable";
            }
            {
              criteria = "DVI-D-1";
              mode = "1920x1080@60Hz";
              position = "0,0";
              scale = 0.8;
              status = "enable";
            }
          ];
        };
        homeIgnoreHDMI = {
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
              scale = 0.8;
              status = "enable";
            }
            {
              criteria = "DVI-D-1";
              mode = "1920x1080@60Hz";
              position = "0,0";
              scale = 0.8;
              status = "enable";
            }
            {
              criteria = "HDMI-A-1";
              status = "disable";
            }
          ];
        };
      };
    };

    # Gnome keyring is required by certain software.
    gnome-keyring.enable = true;

    # Asks for GPG password when needed. About once every 3 minutes.
    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      pinentryFlavor = "qt";
    };

    # Gammastep gradually adjusts color temperature of monitors at sunset and sunrise.
    gammastep = {
      # Tray icon disabled due to me having no tray in the bar at the moment.
      enable = true;
      tray = false;

      # Maximum and minimum gamma values. (6500K is equivalent to daylight).
      temperature = {
        day = 6500;
        night = 4500;
      };

      # Location coordinates (1-2 decimal points is enough).
      latitude = 62.38;
      longitude = 17.32;
    };

    # EasyEffects PipeWire audio filters DAP. To be able to switch between EasyEffects and 
    # other audio for example JamesDSP able this service to avoid conflict with
    # JamesDSP if using that, and just launch EasyEffects or JamesDSP. This service will restart
    # itself if we stop it, and we don't want both of them active.
    easyeffects.enable = true;
  };

  #
  # SYSTEMD
  #

  systemd.user.services.eww = {
    Unit = {
      Description = "EWW configured for River.";
      Documentation = "https://github.com/elkowar/eww";
      PartOf = [ "river-session.target" ];
      After = [ "river-session.target" ];
    };

    Service = {
      # Daemon is started automatically when opening a window.
      ExecStart = "${pkgs.eww-wayland}/bin/eww open bar";
      ExecReload = "${pkgs.eww-wayland}/bin/eww --restart open bar";
      Restart = "on-failure";
      KillMode = "mixed";
    };

    Install.WantedBy = [ "river-session.target" ];
  };

  systemd.user.targets.river-session = {
    Unit = {
      Description = "River compositor session";
      Documentation = [ "man:systemd.special(7)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };

  ##
  # SECURITY
  ##

  pam.yubico.authorizedYubiKeys.ids = [ "ccccccurnfle" "cccccclkvllh" ];
}

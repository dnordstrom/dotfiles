# #
# DNORDSTROM USER CONFIGURATION
#
# Author:       Daniel Nordstrom <d@mrnordstrom.com>
# Repository:   https://github.com/dnordstrom/dotfiles
# #  

{ pkgs, lib, config, ... }:

let
  #
  # SETUP
  #

  # Path used for out of store symlinks to make certain files editable without a rebuild. For
  # example the Sway WM configuration entry point links directly to this directory so that when
  # editing it we don't need to run `nixos-rebuild switch` each time to check the result.
  #
  # Example:
  #
  # ```nix
  # config.lib.file.mkOutOfStoreSymlink "${configDir}/config/sway/config.main"
  # # or
  # home.file.myUserFile.source = configDir config/sway/config.main;
  # ```
  configDir = "/etc/nixos";

  # Convenience method for getting absolute paths based on `configDir`. Leading slash not needed.
  # The `/. +` part coerces the type from string to path.
  #
  # @param {string|path} path - Relative path
  # @returns {path} Absolute path
  configPath = path: /. + "/etc/nixos/${path}";

  #
  # APPLICATIONS
  #

  #
  # General
  #

  browser = "firefox";
  editor = "vim";
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

  # 
  # MIME-TYPES
  # 

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
  # GLOBAL PYTHON PACKAGES
  #

  python-packages = ps: with ps; [ i3ipc requests protonvpn-nm-lib ];
  python-with-packages = pkgs.python3.withPackages python-packages;

in rec {
  #
  # ENVIRONMENT
  #

  home.stateVersion = "22.11";

  home.sessionVariables = {
    EDITOR = editor;
    BROWSER = browser;
    TERMINAL = terminal;
  };

  #
  # XDG ENTRIES AND ASSOCIATIONS
  #

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = mimeAassociations;
      defaultApplications = mimeAassociations;
    };

    desktopEntries = {
      #
      # Desktop applications
      #

      slack-wayland = {
        name = "Slack (Wayland)";
        comment = "Slack Desktop";
        type = "Application";
        genericName = "Slack Client for Linux";
        exec =
          "slack --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland -s %U";
        terminal = false;
        icon = "slack";
        categories = [ "GNOME" "GTK" "Network" "InstantMessaging" ];
        mimeType = [ "x-scheme-handler/slack" ];
        startupNotify = true;
      };

      nemo-without-cinnamon = {
        name = "Nemo (Non-Desktop)";
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
          "appimage-run ${config.home.homeDirectory}/.local/bin/httpie/httpie.appimage %F";
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
          "appimage-run ${config.home.homeDirectory}/.local/bin/ferdium/ferdium.appimage";
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
          "appimage-run ${config.home.homeDirectory}/.local/bin/session/session.appimage";
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
          "GDK_BACKEND=x11 appimage-run ${config.home.homeDirectory}/.local/bin/station/station.appimage";
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
          "GDK_BACKEND=x11 appimage-run ${config.home.homeDirectory}/.local/bin/mymonero/mymonero.appimage -- %U";
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
          "appimage-run ${config.home.homeDirectory}/.local/bin/singlebox/singlebox.appimage -- %U";
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
          "appimage-run ${config.home.homeDirectory}/.local/bin/bitwarden/bitwarden.appimage %U";
        terminal = false;
        icon = "ferdium";
        categories = [ "Utility" ];
        mimeType = [ "x-scheme-handler/bitwarden" ];
        startupNotify = false;
        settings = { StartupWMClass = "Bitwarden"; };
      };

      #
      # Command line applications
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
      # Startup sessions
      #

      kitty-session-cloud = {
        name = "Cloud development (kitty)";
        comment = "Cloud development (kitty)";
        type = "Application";
        genericName = "Text Editor";
        exec = ''
          kitty --session "${configDir}/config/kitty/sessions/dev-cloud.session" --single-instance --instance-group dev
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

      firefoxPrivate = {
        name = "Firefox Nightly (Private)";
        type = "Application";
        genericName = "Web Browser";
        exec = "firefox -P Private %U";
        terminal = false;
        icon = "firefox";
        categories = [ "Network" "WebBrowser" ];
        mimeType = [
          "text/html"
          "text/xml"
          "application/xhtml+xml"
          "application/vnd.mozilla.xul+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/ftp"
        ];
        startupNotify = false;
        settings = { StartupWMClass = "firefox-nightly-private"; };
      };

      firefoxTesting = {
        name = "Firefox Nightly (Testing)";
        type = "Application";
        genericName = "Web Browser";
        exec = "firefox -P Testing %U";
        terminal = false;
        icon = "firefox";
        categories = [ "Network" "WebBrowser" ];
        mimeType = [
          "text/html"
          "text/xml"
          "application/xhtml+xml"
          "application/vnd.mozilla.xul+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/ftp"
        ];
        startupNotify = false;
        settings = { StartupWMClass = "firefox-nightly-testing"; };
      };

      firefoxMusic = {
        name = "Firefox Nightly (Music)";
        type = "Application";
        genericName = "Web Browser";
        exec = "firefox -P Music %U";
        terminal = false;
        icon = "firefox";
        categories = [ "Network" "WebBrowser" ];
        mimeType = [
          "text/html"
          "text/xml"
          "application/xhtml+xml"
          "application/vnd.mozilla.xul+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/ftp"
        ];
        startupNotify = false;
        settings = { StartupWMClass = "firefox-nightly-music"; };
      };
    };
  };

  #
  # PACKAGES
  #

  home.packages = with pkgs; [
    #
    # Local
    #
    # Either grabbed from the nixpkgs GitHub repository and patched to use newer versions, or custom
    # package derivations not available in the repository. Regular packages in the `nordpkgs` list
    # and flake based packages in the main `pkgs` (i.e. no "nordpkgs" prefix).
    #

    nordpkgs.convox
    nordpkgs.lswt

    #
    # Networking
    #

    gnome.networkmanager-openvpn
    haskellPackages.network-manager-tui
    libsForQt5.networkmanager-qt
    networkmanager-openvpn
    networkmanagerapplet
    openvpn3
    qbittorrent

    #
    # Nix
    #

    agenix
    cachix
    nix-prefetch
    nixos-option

    #
    # Programs, packages, and files
    #

    appimage-run
    cinnamon.nemo
    dolphin
    gnome.nautilus

    #
    # Communication
    #

    element-desktop
    fluffychat
    fractal
    gomuks
    gotktrix
    mirage-im
    nheko
    quaternion
    schildichat-desktop-wayland
    signal-desktop
    slack
    slack-term
    weechat

    #
    # Command line
    #

    bottom
    fd
    gh
    libnotify
    awscli2
    mdcat
    ncpamixer # TRY: We ready to let Pavucontrol go?
    neofetch
    onefetch
    pamixer # TRY: ^ See previous question.
    parallel
    rdrview
    ripgrep
    silver-searcher
    tree
    unzip
    usbutils
    vifm-full
    zip

    #
    # Zsh
    #

    zsh-autopair
    zsh-fzf-tab
    zsh-nix-shell
    zsh-vi-mode

    #
    # Wayland
    #

    flameshot
    grim
    imagemagick
    j4-dmenu-desktop
    kile-wl
    libinput
    light # TRY: See how this works for backlight control. Should supposedly work even in TTY.
    river
    rivercarro
    rofi-calc
    rofi-emoji
    rofi-systemd
    rofi-wayland
    slurp
    swappy
    swaybg
    swayidle # TODO: Use systemd service option instead.
    swaylock-effects
    swayr
    swaywsr
    vimiv-qt
    wdisplays
    wev
    wf-recorder
    wl-clipboard
    wofi
    wofi-emoji
    wtype
    xdg_utils # For `xdg-open`
    ydotool

    #
    # Office 
    #

    libreoffice-fresh
    zathura

    #
    # Web
    #

    tor-browser-bundle-bin
    tridactyl-native # Firefox native messaging host

    #
    # Mail
    #

    liferea
    thunderbird

    #
    # Security
    #

    bitwarden
    bitwarden-cli
    git-crypt
    go-2fa
    otpclient
    pinentry-gtk2
    protonmail-bridge
    protonvpn-cli_2
    # Using OpenVPN-based community client since official v3 below has dumbass DE/GUI dependencies.
    # protonvpn-cli
    # protonvpn-gui
    qtpass
    tmpmail
    yubico-pam
    yubico-piv-tool
    yubikey-agent
    yubikey-manager
    yubikey-manager-qt
    yubikey-personalization
    yubikey-personalization-gui
    yubikey-touch-detector
    yubioath-desktop

    #
    # Multimedia
    #

    alsa-firmware
    alsa-tools
    alsa-utils
    audacious
    cava
    celluloid
    deadbeef-with-plugins
    easyeffects # To run as service, use `services.easyeffects` instead (messes with JamesDSP)
    handbrake
    haruna
    jamesdsp
    pavucontrol
    playerctl
    pulsemixer
    streamlink
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
    nlohmann_json
    rnnoise-plugin
    speexdsp
    tbb

    #
    # Development
    #

    # General
    cloudflared
    gcc

    # Editors
    kate

    # LSP and syntax
    # nodePackages.bash-language-server
    # nodePackages.diagnostic-languageserver
    # nodePackages.typescript-language-server
    # nodePackages.vscode-langservers-extracted
    # nodePackages.yaml-language-server
    # rnix-lsp # Uses `nixpkgs-fmt`
    tree-sitter

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
    nixfmt # Opinionated formatter, used by `null-ls`
    statix # Static analysis, used by `null-ls`

    # Rust
    rust-bin.stable.latest.default

    # Go
    gofumpt
    # gopls

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
    # nodePackages.typescript

    # CSS
    # nodePackages.sass
    # nodePackages.stylelint

    # Vim
    # nodePackages.vim-language-server

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

    # Fonts
    corefonts
    fcft # Font loading library used by foot
    font-manager
    jetbrains-mono
    nerd-font-patcher
    powerline-fonts
    victor-mono

    # Qt libs/apps
    libsForQt5.ark
    libsForQt5.kdegraphics-thumbnailers
    libsForQt5.qt5.qtgraphicaleffects # Needed by Quaternion Matrix client
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugins

    # Theming
    gdk-pixbuf
    glib.bin
    gnome.dconf-editor
    gsettings-desktop-schemas
    gtk-engine-murrine
    gtk_engines
    icoutils

    #
    # Interesting prospects
    #

    input-remapper
    interception-tools # and caps2esc plugin, for intercepting at device level instead of WM
    jetbrains.datagrip
    navi # CLI cheatsheet tool
    tealdeer # TLDR in Rust
    ytfzf # Fzf utility for YouTube

    #
    # Dependencies
    #

    # sway-fzfify
    pv
  ];

  #
  # SWAY
  #
  #   We use Home Manager for its systemd integration, not for the actual configuration which is
  #   pretty big and best kept portable in its original format.
  #
  #   Home Manager creates a config file to integrate with DBUS and systemd even if we set `config`
  #   to `null`, so we use `extraConfig` to append a line at the bottom that loads our own.
  #
  #   NOTE: It's advised to run the DBUS command at the bottom so we'll see how well this works.
  #

  wayland.windowManager.sway = {
    enable = true;
    extraConfig = "include config.main";
  };

  #
  # GTK
  #

  gtk = let
    config = { dark = "false"; };
    gtk3Config = { gtk-application-prefer-dark-theme = "${config.dark}"; };
    gtk2Config = ''gtk-application-prefer-dark-theme = "${config.dark}";'';
    bookmarks = [
      "file:///home/dnordstrom/Code"
      "file:///home/dnordstrom/Backup"
      "file:///home/dnordstrom/Pictures/Screenshots"
      "file:///home/dnordstrom/Secrets"
      "file:///home/dnordstrom/.config .config"
      "file:///home/dnordstrom/.local/bin .local  bin"
      "file:///home/dnordstrom/.local/share .local  share"
      "file:///etc/nixos NixOS"
      "file:///etc/nixos/config/firefox NixOS  Config  firefox"
      "file:///etc/nixos/config/nvim NixOS  Config  nvim"
    ];
  in {
    enable = true;
    font = {
      name = "Input Sans Condensed";
      size = 9;
    };
    theme.name = "Catppuccin-yellow"; # No package---manually installed
    iconTheme = {
      name = "Vimix-dark";
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

  #
  # CONFIGURATION FILES
  #
  # Most configuration files are stored in their normal format and here symlinked into ~/.config or
  # wherever appropriate, even for software like Sway WM which can be configured via Home Manager.
  #
  # This is for portability reasons to make the files easier to both share with others and work on.
  # For example, this makes it simple to copy and paste defaults or snippets from online sources,
  # and the files remain useful for those not using NixOS or Home Manager.
  #

  # Scripts and shell

  home.file.".scripts".source = ../scripts;
  home.file.".zshinit".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/zsh/zshrc";

  # Wallpapers

  home.file."Pictures/Wallpapers".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/wallpapers";

  #
  # Dolphin places
  #

  home.file.".config/dolphin/user-places.xbel".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/dolphin/user-places.xbel";

  # EasyEffects
  #
  #   Settings directories are writable but presets directory read-only. This allows EasyEffects
  #   to modify its settings while the presets are immutable since that's where the important
  #   presets are saved.
  #
  #   Also see `services.easyeffects` for background service.

  home.file.".config/easyeffects/output".source =
    config.lib.file.mkOutOfStoreSymlink
    "${configDir}/config/easyeffects/output";
  home.file.".config/easyeffects/input".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/easyeffects/input";
  home.file.".config/easyeffects/irs".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/easyeffects/irs";
  home.file.".config/easyeffects/autoload".source =
    config.lib.file.mkOutOfStoreSymlink
    "${configDir}/config/easyeffects/autoload";
  xdg.configFile."easyeffects/presets".source = ../config/easyeffects/presets;

  # Sway
  #
  #   We can't symlink the `~/.config/sway` directory when using home manager, we have to symlink
  #   individual files. For somre reason `xdg.configFile` doesn't work so we use `home.file`.

  home.file.".config/sway/start".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/sway/start";
  home.file.".config/sway/config.main".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/sway/config.main";
  home.file.".config/sway/colors.catppuccin".source =
    config.lib.file.mkOutOfStoreSymlink
    "${configDir}/config/sway/colors.catppuccin";

  home.file.".config/swaylock/config".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/swaylock/config";
  home.file.".config/swaynag/config".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/swaynag/config";

  # River

  home.file.".config/river".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/river";

  # Swappy 

  xdg.configFile."swappy/config".source = ../config/swappy/config;

  # Kitty

  home.file.".config/kitty/config.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/kitty/config.conf";
  home.file.".config/kitty/open-actions.conf".source =
    config.lib.file.mkOutOfStoreSymlink
    "${configDir}/config/kitty/open-actions.conf";
  home.file.".config/kitty/themes".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/kitty/themes";
  home.file.".config/kitty/sessions".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/kitty/sessions";
  home.file.".config/kitty/kittens".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/kitty/kittens";

  # Starship

  xdg.configFile."starship.toml".source = ../config/starship/starship.toml;

  # Zathura

  xdg.configFile."zathura".source = ../config/zathura;

  # Firefox

  home.file.".config/tridactyl".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/firefox/tridactyl";

  home.file.".mozilla/native-messaging-hosts/tridactyl.json".source =
    "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";

  # Neovim

  home.file.".config/nvim/lua".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/nvim/lua";
  home.file.".config/nvim/ftplugin".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/nvim/ftplugin";
  home.file.".config/nvim/luasnippets".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/nvim/luasnippets";
  home.file.".config/nvim/spell".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/nvim/spell";

  # Vifm

  home.file.".config/vifm".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/vifm";

  # Glow

  home.file.".config/glow".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/glow";

  # lsd

  home.file.".config/lsd".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/lsd";

  # Wofi

  home.file.".config/wofi".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/wofi";

  # Waybar

  home.file.".config/waybar".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/config/waybar";

  #
  # PROGRAMS
  #

  programs.exa.enable = true;
  programs.java.enable = true;
  programs.jq.enable = true;
  programs.lsd.enable = true;
  programs.mpv.enable = true;

  programs.waybar = {
    enable = true;
    systemd.target = "sway-session.target";
  };

  programs.eww = {
    enable = true;
    configDir = config.lib.file.mkOutOfStoreSymlink "${configDir}/config/eww";
    package = pkgs.eww-wayland;
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.pet = {
    enable = true;
    snippets = [
      {
        description = "Set GTK theme";
        command = "gsettings set org.gnome.desktop.interface gtk-theme";
        tag = [ "gtk" "gnome" "theme" "configuration" ];
      }
      {
        description = "Copy Firefox password";
        command =
          "bw get item Firefox | jq -r '.login.password // empty' | wl-copy";
        tag = [ "password" "copy" "clipboard" "json" ];
      }
    ];
  };

  programs.firefox = let
    config = {
      # Disable annoyances
      "browser.aboutConfig.showWarning" = false;
      "browser.shell.checkDefaultBrowser" = false;
      "browser.bookmarks.restore_default_bookmarks" = false;
      "extensions.webextensions.restrictedDomains" = "";

      # Enable userChrome.css and userContent.css
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

      # Enable showing compact mode option
      "browser.compactmode.show" = true;

      # Enable legacy screen share indicator that works better in Wayland
      "privacy.webrtc.legacyGlobalIndicator" = false;

      # Needed to make certain key combinations work with Tridactyl
      "privacy.resistFingerprinting" = false;
      "privacy.resistFingerprinting.block_mozAddonManager" = false;
    };
  in {
    enable = true;
    package =
      pkgs.latest.firefox-nightly-bin; # From `nixpkgs-mozilla` flake and overlay
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

  programs.kitty = {
    enable = true;
    extraConfig = "include ./config.conf";
  };

  programs.git = {
    enable = true;
    userName = "dnordstrom";
    userEmail = "d@mrnordstrom.com";
    aliases = {
      c = "commit -am";
      s = "status";
      b = "branch";
      f = "fetch";
      p = "push";
    };
  };

  programs.chromium = {
    enable = true;
    extensions = [
      {
        # 1Password
        id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";
      }
      {
        # uBlock Origin
        id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
      }
    ];
  };

  programs.neovim = {
    package = pkgs.neovim-nightly;
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = "lua require('init')";
  };

  programs.zsh = {
    autocd = true;
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;

    cdpath = [
      "${config.home.homeDirectory}"
      "${config.home.homeDirectory}/Code"
      "${configDir}"
    ];

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

    # Source our config from `~/.zshinit` which is a symlink to `${configDir}/config/zsh/zshrc`.
    initExtra = "source ${config.home.homeDirectory}/.zshinit";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config = {
      color = "always";
      italic-text = "always";
      tabs = "2";
      theme = "base16";
      style = "header-filename,header-filesize,rule,numbers,changes";
    };
  };

  # Fuzzy finder written in Go

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = false;
    enableBashIntegration = false;
  };

  programs.go = {
    enable = true;
    goPath = "${config.home.homeDirectory}/.local/bin/go"; # Don't use `~/go`...
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.mako = {
    actions = true;
    backgroundColor = "#B7E5E6";
    borderColor = "#6E6C7E";
    borderRadius = 0;
    defaultTimeout = 5000;
    enable = true;
    icons = true;
    maxIconSize = 48;
    iconPath = "/etc/profiles/per-user/dnordstrom/share/icons/Papirus-Dark";
    font = "Input Sans Condensed 8";
    margin = "12";
    markup = true;
    padding = "12,24";
    textColor = "#1E1E28";
    width = 325;
  };

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

  programs.gpg.enable = true;

  #
  # MANUAL
  #

  manual = {
    # Installs `home-manager-help` tool.
    html.enable = true;

    # Installs to `<profile>/share/doc/home-manager/options.json`.
    json.enable = true;
  };

  #
  # SERVICES
  #

  services.gnome-keyring.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt";
  };

  services.gammastep = {
    enable = true;
    temperature = {
      day = 6500;
      night = 5000;
    };
    tray = true;
    latitude = 63.2;
    longitude = 17.3;
  };

  # We're using the package instead of this service since it messes with JamesDSP.
  services.easyeffects.enable = false;

  #
  # Systemd
  #

  # Proton email bridge

  systemd.user.services.protonmail-bridge = {
    Unit = {
      Description = "ProtonMail Bridge";
      After = [ "network.target" ];
    };
    Service = {
      Restart = "always";
      ExecStart =
        "${pkgs.protonmail-bridge}/bin/protonmail-bridge --cli --noninteractive";
    };
    Install = { WantedBy = [ "default.target" ]; };
  };

  #
  # SECURITY
  #

  pam.yubico.authorizedYubiKeys.ids = [ "ccccccurnfle" "cccccclkvllh" ];
}

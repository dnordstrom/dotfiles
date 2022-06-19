# #
# USER MODULE: DNORDSTROM
#
# Author: Daniel Nordstrom <d@mrnordstrom.com>
# Repository: https://github.com/dnordstrom/dotfiles
# #  

{ pkgs, nixpkgs, lib, config, ... }:

let
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

  python-packages = ps: with ps; [ i3ipc requests ];
  python-with-packages = pkgs.python3.withPackages python-packages;

in {
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

      httpie-appimage = {
        name = "HTTPie";
        type = "Application";
        genericName = "Modern HTTP client for the API era";
        exec =
          "appimage-run /home/dnordstrom/.local/bin/httpie/httpie.appimage %F";
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
          "appimage-run /home/dnordstrom/.local/bin/ferdium/ferdium.appimage";
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
          "appimage-run /home/dnordstrom/.local/bin/session/session.appimage";
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
          "GDK_BACKEND=x11 appimage-run /home/dnordstrom/.local/bin/station/station.appimage";
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
          "GDK_BACKEND=x11 appimage-run /home/dnordstrom/.local/bin/mymonero/mymonero.appimage -- %U";
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
          "appimage-run /home/dnordstrom/.local/bin/singlebox/singlebox.appimage -- %U";
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
          "appimage-run /home/dnordstrom/.local/bin/bitwarden/bitwarden.appimage %U";
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

      neovim-alacritty = {
        name = "Neovim (Alacritty)";
        type = "Application";
        genericName = "Text Editor";
        exec = "alacritty --title popupterm -e nvim %F";
        terminal = false;
        icon = "nvim";
        categories = [ "Utility" "TextEditor" "Development" "IDE" ];
        mimeType = [ "text/plain" "inode/directory" ];
        startupNotify = false;
      };

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

      vifm-alacritty = {
        name = "Vifm (Alacritty)";
        type = "Application";
        genericName = "File Manager";
        exec = "alacritty --title popupterm -e vifm %F";
        terminal = false;
        icon = "vifm";
        categories = [ "Utility" "TextEditor" "Development" "IDE" ];
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
        exec =
          "kitty --session /etc/nixos/config/kitty/dev-cloud.session --single-instance --instance-group dev";
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
    # package derivations not available in the repository.
    #

    nordpkgs.convox # Not in nixpkgs

    #
    # Networking
    #

    gnome.gnome-keyring
    haskellPackages.network-manager-tui
    libgnome-keyring
    openvpn
    qbittorrent

    #
    # Nix
    #

    agenix
    cachix
    nix-prefetch

    #
    # Programs, packages, and files
    #

    appimage-run
    dolphin
    dmg2img

    #
    # Communication
    #

    element-desktop
    fluffychat
    fractal
    gotktrix
    mirage-im
    neochat
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

    awscli2
    bottom
    fd
    gh
    libnotify
    onefetch # Git summary
    neofetch # System summary
    parallel
    rdrview # URL article viewer based on Firefox's Readability
    ripgrep
    tree
    unzip
    usbutils
    vifm-full
    xclip
    xdotool
    xsel
    zip

    #
    # Zsh plugins
    #

    zsh-autopair
    zsh-fzf-tab
    zsh-nix-shell
    zsh-vi-mode

    #
    # Virtualization
    #

    winetricks
    wineWowPackages.waylandFull

    #
    # Wayland
    #

    # Sway
    swayidle # TODO: Use systemd service option instead.
    swaylock-effects
    swaywsr

    # Screenshots
    flameshot
    grim
    imagemagick
    slurp
    swappy

    # Images
    vimiv-qt

    # Recording and wl-clipboard
    wf-recorder
    wl-clipboard

    # Monitor
    wdisplays

    # Launchers
    wofi
    rofi-calc
    rofi-emoji
    rofi-systemd
    rofi-wayland
    j4-dmenu-desktop
    wofi-emoji
    xdg_utils # For xdg-open

    # Input
    libinput
    wev
    wtype
    ydotool

    #
    # Office 
    #

    libreoffice-fresh
    zathura

    #
    # Web browsing
    #

    tor-browser-bundle-bin
    tridactyl-native # Firefox native messaging host

    #
    # Email
    #

    liferea
    thunderbird

    #
    # Security
    #

    bitwarden
    bitwarden-cli
    go-2fa
    pinentry-gtk2
    protonmail-bridge
    protonvpn-cli
    protonvpn-gui
    qtpass

    #
    # Multimedia
    #

    alsa-firmware
    alsa-tools
    alsa-utils
    audacious
    cava
    celluloid # GTK frontend for MPV
    deadbeef-with-plugins
    easyeffects # To run as service, use `services.easyeffects` instead (messes with JamesDSP)
    handbrake
    haruna # QT frontend for MPV
    jamesdsp
    pavucontrol
    pulseaudio
    pulsemixer
    strawberry

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
    cloudflared # Cloudflare Tunnel daemon for remote access to localhost
    gcc

    # Editors
    kate

    # LSP and syntax
    nodePackages.vscode-langservers-extracted # HTML, CSS, and JSON
    nodePackages.typescript-language-server
    nodePackages.diagnostic-languageserver
    nodePackages.yaml-language-server
    nodePackages.bash-language-server
    rnix-lsp # Uses nixpkgs-fmt
    tree-sitter

    # Writing
    proselint
    glow

    # Git
    bfg-repo-cleaner

    # Nix
    nixfmt # Opinionated formatter, used by null-ls
    nixos-option # Finds option values and where they're declared
    statix # Static analysis, used by null-ls

    # Rust
    rust-bin.stable.latest.default

    # Go
    gofumpt
    gopls

    # Lua
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
    nodePackages.typescript

    # CSS
    nodePackages.sass
    nodePackages.stylelint

    # Vim
    nodePackages.vim-language-server

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
    jetbrains-mono
    powerline-fonts
    victor-mono
    fcft # Font loading library used by foot
    font-manager

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
    gnome.nautilus
    gsettings-desktop-schemas
    gtk-engine-murrine
    gtk_engines
    icoutils

    # Themes
    vimix-icon-theme
    quintom-cursor-theme

    #
    # Interesting prospects
    #

    swayr
    mdcat
    interception-tools # and caps2esc plugin, for intercepting at device level instead of WM
    navi # CLI cheatsheet tool
    tealdeer # TLDR in Rust
    tmpmail # CLI temporary email generator
    yubikey-personalization-gui
    yubikey-personalization
    yubico-pam
    yubikey-agent
    yubikey-manager
    yubico-piv-tool
    yubioath-desktop
    yubikey-manager-qt
    yubikey-touch-detector
    otpclient
    git-crypt
    jetbrains.datagrip

    #
    # Dependencies
    #

    # sway-fzfify
    pv
  ];

  #
  # SWAY
  #
  #   Creates an empty config from which we load our own. We use Home Manager for its `systemd`
  #   integration, not the configuration.
  #

  wayland.windowManager.sway = {
    enable = true;
    config = null;
    extraConfig = "include config.main";
    extraSessionCommands = ''
      # Firefox
      export MOZ_ENABLE_WAYLAND=1
      export MOZ_DBUS_REMOTE=1
      export MOZ_USE_XINPUT2=1

      # Wayland
      export QT_QPA_PLATFORM=wayland
      export QT_STYLE_OVERRIDE=qt5ct-style
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export GDK_BACKEND=wayland

      # Sway
      export XDG_CURRENT_DESKTOP=sway
      export XDG_SESSION_DESKTOP=sway
      export XDG_SESSION_TYPE=wayland

      # Java
      export _JAVA_AWT_WM_NONREPARENTING=1

      # Miscellaneous
      export SDL_VIDEODRIVER=wayland
    '';
  };

  #
  # QT
  #

  qt.enable = true;

  #
  # GTK
  #

  gtk = {
    enable = true;
    font = {
      name = "Input Sans Condensed";
      size = 9;
    };
    theme.name = "Catppuccin-yellow";
    iconTheme.name = "Vimix-dark";
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = "true";
      extraCss = "";
    };
    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = "true"
    '';
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

  # Scripts

  home.file.".scripts".source = ../scripts;

  # Wallpapers

  home.file."Pictures/Wallpapers".source =
    config.lib.file.mkOutOfStoreSymlink /etc/nixos/wallpapers;

  # EasyEffects
  #
  #   Settings directories are writable but presets direcotory read-only. This allows EasyEffects
  #   to modify its settings while the presets are immutable since that's where the important
  #   presets are saved.
  #
  #   Also see `services.easyeffects` for background service.

  xdg.configFile."easyeffects/output".source =
    config.lib.file.mkOutOfStoreSymlink /etc/nixos/config/easyeffects/output;
  xdg.configFile."easyeffects/input".source =
    config.lib.file.mkOutOfStoreSymlink /etc/nixos/config/easyeffects/input;
  xdg.configFile."easyeffects/irs".source =
    config.lib.file.mkOutOfStoreSymlink /etc/nixos/config/easyeffects/irs;
  xdg.configFile."easyeffects/autoload".source =
    config.lib.file.mkOutOfStoreSymlink /etc/nixos/config/easyeffects/autoload;
  xdg.configFile."easyeffects/presets".source = ../config/easyeffects/presets;

  # Sway
  #
  #   We can't symlink the `~/.config/sway` directory when using home manager, we have to symlink
  #   individual files. For somre reason `xdg.configFile` doesn't work so we use `home.file`.

  home.file.".config/sway/config.main".source =
    config.lib.file.mkOutOfStoreSymlink /etc/nixos/config/sway/config.main;
  home.file.".config/sway/colors.catppuccin".source =
    config.lib.file.mkOutOfStoreSymlink
    /etc/nixos/config/sway/colors.catppuccin;

  xdg.configFile."swaylock/config".source =
    config.lib.file.mkOutOfStoreSymlink /etc/nixos/config/swaylock/config;
  xdg.configFile."swaynag/config".source =
    config.lib.file.mkOutOfStoreSymlink /etc/nixos/config/swaynag/config;

  # Swappy 

  xdg.configFile."swappy/config".source = ../config/swappy/config;

  # Kitty

  xdg.configFile."kitty".source = ../config/kitty;

  # Wezterm

  xdg.configFile."wezterm".source = ../config/wezterm;

  # tmux

  xdg.configFile."tmux".source = ../config/tmux;

  # Starship

  xdg.configFile."starship.toml".source = ../config/starship/starship.toml;

  # Zathura

  xdg.configFile."zathura".source = ../config/zathura;

  # Firefox

  xdg.configFile."tridactyl".source =
    config.lib.file.mkOutOfStoreSymlink /etc/nixos/config/firefox/tridactyl;

  home.file.".mozilla/native-messaging-hosts/tridactyl.json".source =
    "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";

  # Neovim

  xdg.configFile."nvim/lua".source =
    config.lib.file.mkOutOfStoreSymlink /etc/nixos/config/nvim/lua;
  xdg.configFile."nvim/ftplugin".source =
    config.lib.file.mkOutOfStoreSymlink /etc/nixos/config/nvim/ftplugin;
  xdg.configFile."nvim/luasnippets".source =
    config.lib.file.mkOutOfStoreSymlink /etc/nixos/config/nvim/luasnippets;

  # Vifm

  xdg.configFile."vifm".source = ../config/vifm;

  # Glow

  xdg.configFile."glow".source = ../config/glow;

  # Wofi

  xdg.configFile."wofi".source =
    config.lib.file.mkOutOfStoreSymlink /etc/nixos/config/wofi;

  # Waybar

  xdg.configFile."waybar".source =
    config.lib.file.mkOutOfStoreSymlink /etc/nixos/config/waybar;

  # wlogout

  xdg.configFile."wlogout/layout".source = ../config/wlogout/layout;
  xdg.configFile."wlogout/style.css".source = ../config/wlogout/style.css;
  xdg.configFile."wlogout/lock.png".source = ../config/wlogout/lock.png;
  xdg.configFile."wlogout/logout.png".source = ../config/wlogout/logout.png;
  xdg.configFile."wlogout/reboot.png".source = ../config/wlogout/reboot.png;
  xdg.configFile."wlogout/shutdown.png".source = ../config/wlogout/shutdown.png;

  # Alacritty

  xdg.configFile."alacritty/alacritty.yml".source =
    ../config/alacritty/alacritty.yml;

  # Foot

  xdg.configFile."foot".source = ../config/foot;

  #
  # PROGRAMS
  #

  programs.foot = {
    enable = true;
    server.enable = true;
  };

  programs.qutebrowser.enable = false;
  programs.nnn.enable = false;
  programs.feh.enable = false;
  programs.java.enable = true;
  programs.jq.enable = true;
  programs.mpv.enable = true;
  programs.afew.enable = false;
  programs.mbsync.enable = false;

  programs.waybar = {
    enable = true;
    systemd.target = "sway-session.target";
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.password-store = {
    enable = false;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.nushell = {
    enable = false;
    settings = {
      startup = [
        # Shortcuts
        "alias l = ls -a"
        "alias e = echo"

        # Initialize Starship prompt
        "mkdir ~/.cache/starship"
        "starship init nu | save ~/.cache/starship/init.nu"
        "source ~/.cache/starship/init.nu"
      ];

      # Use Starship prompt
      prompt = "starship_prompt";
    };
  };

  programs.exa = {
    enable = true;
    enableAliases = false; # Adds ls, ll, la, lt, and lla
  };

  programs.lsd = {
    enable = true;
    enableAliases = false; # Adds ls, ll, la, lt, and lla
    settings = {
      date = "relative";
      display = "almost-all";
      layout = "tree";
      sorting = {
        column = "name";
        dir-grouping = "first";
      };
    };
  };

  programs.pet = {
    enable = true;
    snippets = [{
      description = "Set GTK theme";
      command = "gsettings set org.gnome.desktop.interface gtk-theme";
      tag = [ "gtk" "gnome" "theme" "configuration" ];
    }];
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
    package = pkgs.firefox-nightly-bin;
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

  programs.kitty.enable = true;

  programs.alacritty.enable = true;

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
    extraConfig = builtins.readFile ../config/nvim/init.vim;
  };

  programs.zsh = {
    autocd = true;
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;

    cdpath = [ "$HOME" "$HOME/Code" "/etc/nixos" ];

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
        src = pkgs.fetchFromGitHub {
          owner = "momo-lab";
          repo = "zsh-abbrev-alias";
          rev = "33fe094da0a70e279e1cc5376a3d7cb7a5343df5";
          sha256 = "sha256-jq5YEpIpvmBa/M7F4NeC77mE9WHSnza3tZwvgMPab7M=";
        };
        file = "abbrev-alias.plugin.zsh";
      }
      {
        name = "doas";
        src = pkgs.fetchFromGitHub {
          owner = "Senderman";
          repo = "doas-zsh-plugin";
          rev = "f5c58a34df2f8e934b52b4b921a618b76aff96ba";
          sha256 = "sha256-136DzYG4v/TuCeJatqS6l7qr7bItEJxENozpUGedJ9o=";
        };
        file = "doas.plugin.zsh";
      }
    ];

    initExtra = builtins.readFile ../config/zsh/zshrc;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true; # Adds eval "$(zoxide init zsh)" to .zshrc
  };

  programs.tmux = { enable = true; };

  programs.bat = {
    enable = true;
    config = {
      theme = "base16-256"; # Uses terminal colors
      style = "numbers,changes"; # Shows line numbers and Git changes
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
    goPath = ".go"; # By default not a hidden directory
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
    font = "Input Sans Compressed 8";
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

  programs.gpg = { enable = true; };

  programs.rbw = {
    enable = true;

    # Settings are currently not working so we manage the config manually, see GH issue.
    #
    # settings = {
    #   email = "d@mrnordstrom.com";
    #   pinentry = "curses";
    # };
  };

  #
  # MANUAL
  #

  manual = {
    html.enable = true; # Installs `home-manager-help` tool
    json.enable =
      true; # Installs to `<profile>/share/doc/home-manager/options.json`.
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
    tray = true;
    temperature = {
      day = 6500;
      night = 5000;
    };
    latitude = 63.2;
    longitude = 17.3;
  };

  services.easyeffects.enable = false; # If false, use easyeffects package.

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

  pam.yubico.authorizedYubiKeys.ids = [ "ccccccurnfle" ];
}

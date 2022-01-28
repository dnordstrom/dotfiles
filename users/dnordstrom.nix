{ pkgs, nixpkgs, lib, ... }:

let
  editor = "nvim";
  browser = "firefox";
  terminal = "kitty";
  xdgEditor = [ "neovim-kitty.desktop" ];
  xdgMarkdown = [ "neovim-kitty.desktop" ];
  xdgBrowser = [ "firefox.desktop" ];
  xdgPdfViewer = [ "zathura.desktop" ];
  xdgFileBrowser = [ "dolphine.desktop" ];
  xdgImageViewer = [ "imv-qt.desktop" ];
  xdgMediaPlayer = [ "haruna.desktop" ];
  mimeAassociations = {
    "audio/*" = xdgMediaPlayer;
    "video/*" = xdgMediaPlayer;
    "image/*" = xdgImageViewer;
    "inode/directory" = xdgFileBrowser;
    "text/html" = xdgBrowser;
    "text/plain" = xdgEditor;
    "text/markdown" = xdgEditor;
    "text/calendar" = xdgBrowser;
    "x-scheme-handler/http" = xdgBrowser;
    "x-scheme-handler/https" = xdgBrowser;
    "x-scheme-handler/ftp" = xdgBrowser;
    "x-scheme-handler/chrome" = xdgBrowser;
    "x-scheme-handler/about" = xdgBrowser;
    "x-scheme-handler/unknown" = xdgBrowser;
    "application/pdf" = xdgPdfViewer;
    "application/json" = xdgEditor;
    "application/zip" = xdgFileBrowser;
    "application/x-compressed-tar" = xdgFileBrowser;
    "application/xhtml+xml" = xdgBrowser;
    "application/x-extension-htm" = xdgBrowser;
    "application/x-extension-html" = xdgBrowser;
    "application/x-extension-shtml" = xdgBrowser;
    "application/x-extension-xhtml" = xdgBrowser;
    "application/x-extension-xht" = xdgBrowser;
  };
  python-packages = ps: with ps; [ i3ipc requests ];
  python-with-packages = pkgs.python3.withPackages python-packages;
in {
  #
  # MODULES
  #

  imports = [ ../modules/vscode.nix ];

  #
  # ENVIRONMENT
  #

  home.stateVersion = "22.05";
  home.sessionVariables = {
    EDITOR = editor;
    BROWSER = browser;
    TERMINAL = terminal;
  };

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = mimeAassociations;
      defaultApplications = mimeAassociations;
    };
    desktopEntries = {
      neovim-alacritty = {
        name = "Neovim (Alacritty)";
        type = "Application";
        genericName = "Text Editor";
        exec = "alacritty --class popupterm --title popupterm -e nvim %F";
        terminal = false;
        icon = "nvim";
        categories = [ "Utility" "TextEditor" "Development" "IDE" ];
        mimeType = [ "text/plain" "inode/directory" ];
        startupNotify = false;
      };
      vifm-alacritty = {
        name = "Vifm (Alacritty)";
        type = "Application";
        genericName = "File Manager";
        exec = "alacritty --class popupterm --title popupterm -e vifm %F";
        terminal = false;
        icon = "vifm";
        categories = [ "Utility" "TextEditor" "Development" "IDE" ];
        mimeType = [ "text/plain" "inode/directory" ];
        startupNotify = false;
      };
      neovim-kitty = {
        name = "Neovim (kitty)";
        type = "Application";
        genericName = "Text Editor";
        exec = "kitty --class vimterm -e nvim %F";
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
        exec = "kitty --class popupterm --title popupterm -e vifm %F";
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
        exec = "kitty --class popupterm --title popupterm -e glow %F";
        terminal = false;
        icon = "kitty";
        categories = [ "Utility" "TextEditor" ];
        mimeType = [ "text/markdown" ];
        startupNotify = false;
      };
      slack-wayland = {
        name = "Slack (Wayland)";
        comment = "Slack Desktop";
        type = "Application";
        genericName = "Slack Client for Linux";
        exec =
          "slack --enable-features=UseOzonePlatform --ozone-platform=wayland -s %U";
        terminal = false;
        icon = "slack";
        categories = [ "GNOME" "GTK" "Network" "InstantMessaging" ];
        mimeType = [ "x-scheme-handler/slack" ];
        startupNotify = true;
      };
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
    };
  };

  #
  # PACKAGES
  #

  home.packages = with pkgs; [
    #
    # Local
    #

    nordpkgs.hydroxide
    nordpkgs.convox
    nordpkgs.jira-cli
    nordpkgs.protoncheck
    nordpkgs.protonvpn-gui
    nordpkgs.protonvpn-cli

    #
    # Networking
    #

    networkmanager-openvpn
    openvpn
    nm-tray
    speedcrunch
    gnome.gnome-keyring
    libgnome-keyring
    ytmdesktop
    enlightenment.econnman
    krita
    qview

    #
    # Nix
    #

    cachix
    nix-prefetch

    #
    # Networking
    #

    networkmanager_dmenu

    # General
    appimage-run
    dolphin
    element-desktop
    fractal
    gcc
    guvcview
    lynx
    nextcloud-client
    pavucontrol
    pulseaudio # For pactl since pw-cli makes me cry
    qbittorrent
    signal-desktop
    slack
    spotify
    sqlite
    tor-browser-bundle-bin
    zathura

    # Command line
    awscli2
    bitwarden-cli
    fd
    figlet
    fortune
    gh
    glow
    gotop
    libnotify
    lolcat
    neo-cowsay
    onefetch # Git summary
    neofetch # System summary
    parallel
    rdrview # URL article viewer based on Firefox's Readability
    ripgrep
    t-rec
    toilet
    tree
    usbutils # For lsusb
    vifm-full
    weechat
    xclip
    xdotool
    xorg.xev
    xsel

    #
    # Zsh plugins, sourced in `program.zsh.interactiveShellInit`
    #

    zsh-fzf-tab
    zsh-nix-shell

    # Notifications
    fnott # Keyboard driven notification daemon

    # Wayland layer shell, panels, and effects
    nwg-drawer
    nwg-launchers
    nwg-menu
    nwg-panel
    nwg-panel
    swayidle
    swaylock-effects
    swaywsr
    swaykbdd

    # Screenshots
    grim
    imagemagick
    slurp
    swappy

    # Images
    imv
    vimiv-qt # QT image viewer
    kanshi

    # Recording and wl-clipboard
    wf-recorder
    wl-clipboard

    # Dashboards
    wlogout

    # Monitor
    wdisplays
    wlsunset

    # Launchers
    masterPackages.wofi
    ulauncher
    wofi-emoji
    workstyle

    # Window managers
    # river - Requires wlroots 0.14 while 0.15 is installed: check out why it doesn't work

    # Input
    libinput # For trackpad gestures
    swaykbdd
    wev
    wtype
    ydotool

    #
    # UI toolkits and libraries
    #

    glib
    gnome-breeze
    gnome.dconf-editor
    gnomeExtensions.gsconnect
    gsettings-desktop-schemas
    gsettings-qt
    packagekit
    libsForQt5.packagekit-qt # For installing some KDE services
    libsForQt5.kpackage

    #
    # Web browsing
    #

    tridactyl-native # Firefox native messaging host
    luakit # GTK, WebKit, Lua

    #
    # Email
    #

    electron-mail
    protonmail-bridge
    thunderbird

    #
    # Security
    #

    authy
    bitwarden
    go-2fa
    qtpass
    pinentry-gtk2

    #
    # Multimedia
    #

    celluloid
    clementineUnfree # Unfree for Spotify integration
    handbrake
    haruna
    smplayer
    sayonara
    spicetify-cli
    spotify-qt
    spotify-tui
    spotify-tray
    spotifyd

    #
    # Development
    #

    # Editors
    jetbrains.goland
    jetbrains.idea-ultimate
    jetbrains.webstorm

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

    # Git
    bfg-repo-cleaner

    # Nix
    nixfmt # Opinionated formatter, used by null-ls
    nixpkgs-fmt # Another formatter
    nixpkgs-lint
    vgo2nix # Go modules to packages
    statix # Static analysis

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
    nodePackages.stylelint

    # Vim
    nodePackages.vim-language-server

    # Yaml

    #
    # Appearance
    #

    # Fonts
    corefonts
    fontforge
    jetbrains-mono
    line-awesome
    powerline-fonts

    # Qt libs
    libsForQt5.ark
    libsForQt5.qqc2-breeze-style
    libsForQt5.breeze-gtk
    libsForQt5.breeze-qt5
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5.qtwayland
    libsForQt5.qtcurve
    qgnomeplatform

    # Theming
    icoutils
    masterPackages.themechanger
    qt5ct
    gtk-engine-murrine
    gtk_engines
    lxappearance
    flashfocus

    # Themes
    nordic # GTK, QT, and Kvantum
    masterPackages.ayu-theme-gtk
    dracula-theme
    arc-icon-theme
    paper-icon-theme
    papirus-icon-theme
    flat-remix-icon-theme
    moka-icon-theme # Fallback for Arc icon theme
    vimix-icon-theme
    capitaine-cursors
    numix-cursor-theme
    numix-gtk-theme
    numix-sx-gtk-theme
    numix-icon-theme
    numix-icon-theme-circle
    numix-icon-theme-square
    quintom-cursor-theme
    zafiro-icons

    #
    # Interesting prospects
    #

    swayr
    quaternion
    nheko
    neochat
    mdcat
    mkchromecast
    gnomecast
    castnow
    go-chromecast
    fx_cast_bridge
    interception-tools # and caps2esc plugin, for intercepting at device level instead of WM
    corgi # CLI workflow manager
    navi # CLI cheatsheet tool
    tealdeer # TLDR in Rust
    tmpmail # CLI temporary email generator
    httpie # HTTP client, simpler alternative to cURL
    brave
    pcmanfm-qt
    gnome.nautilus
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
    CuboCore.corefm
    CuboCore.libcsys
    CuboCore.corepdf
    CuboCore.corepad
    CuboCore.coretime
    CuboCore.coreshot
    CuboCore.corehunt
    CuboCore.corestuff
    CuboCore.coreimage
    CuboCore.corestats
    CuboCore.coregarage
    CuboCore.corerenamer
    CuboCore.coreterminal
    CuboCore.corearchiver
    CuboCore.coretoppings
    krusader
    git-crypt
    cliphist
    jetbrains.datagrip

    # Calculator tryouts
    libsForQt5.kcalc
    pro-office-calculator
    gnome.gnome-calculator
    lumina.lumina-calculator

    #
    # Dependencies
    #

    # sway-fzfify
    pv
  ];

  #
  # SWAY
  #

  wayland.windowManager.sway = {
    enable = true;
    config = null;
    extraSessionCommands = ''
      export GDK_BACKEND=wayland
      export MOZ_ENABLE_WAYLAND=1
      export MOZ_USE_XINPUT2=1
      export QT_QPA_PLATFORM=wayland
      export QT_QPA_PLATFORMTHEME=gnome
      export QT_STYLE_OVERRIDE=kvantum
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export SDL_VIDEODRIVER=wayland
      export XDG_CURRENT_DESKTOP=sway
      export XDG_SESSION_DESKTOP=sway
      export XDG_SESSION_TYPE=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

  #
  # QT
  #

  qt = {
    enable = true;
    platformTheme = "gtk";
    style = { name = "kvantum"; };
  };

  #
  # GTK
  #

  gtk = {
    enable = true;
    font = {
      name = "Input Sans Condensed";
      size = 8;
    };
    theme.name = "Dracula";
    iconTheme.name = "Zafiro-icons";
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

  # Secrets

  home.file.".env".source = ../secrets/env;

  # Scripts

  home.file.".scripts".source = ../scripts;

  # Sway

  xdg.configFile."sway".source = ../config/sway;
  xdg.configFile."swaylock/config".source = ../config/swaylock/config;
  xdg.configFile."swaynag/config".source = ../config/swaynag/config;

  # Swappy 

  xdg.configFile."swappy/config".source = ../config/swappy/config;

  # Kitty

  xdg.configFile."kitty".source = ../config/kitty;

  # tmux

  xdg.configFile."tmux".source = ../config/tmux;

  # Starship

  xdg.configFile."starship.toml".source = ../config/starship/starship.toml;

  # Firefox

  xdg.configFile."tridactyl".source = ../config/firefox/tridactyl;

  home.file.".mozilla/native-messaging-hosts/tridactyl.json".source =
    "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";

  # Neovim

  xdg.configFile."nvim/lua".source = ../config/nvim/lua;
  xdg.configFile."nvim/ftplugin".source = ../config/nvim/ftplugin;

  # Vifm

  xdg.configFile."vifm".source = ../config/vifm;

  # Glow

  xdg.configFile."glow".source = ../config/glow;

  # Xorg

  home.file.".xinitrc".source = ../config/xorg/xinitrc.sh;

  # Wofi

  xdg.configFile."wofi".source = ../config/wofi;

  # Waybar

  xdg.configFile."waybar".source = ../config/waybar;

  # wlogout

  xdg.configFile."wlogout/layout".source = ../config/wlogout/layout;
  xdg.configFile."wlogout/style.css".source = ../config/wlogout/style.css;
  xdg.configFile."wlogout/lock.png".source = ../config/wlogout/lock.png;
  xdg.configFile."wlogout/logout.png".source = ../config/wlogout/logout.png;
  xdg.configFile."wlogout/reboot.png".source = ../config/wlogout/reboot.png;
  xdg.configFile."wlogout/shutdown.png".source = ../config/wlogout/shutdown.png;

  # dircolors

  home.file.".dir_colors".source = builtins.fetchurl {
    url =
      "https://github.com/arcticicestudio/nord-dircolors/releases/download/v0.2.0/dir_colors";
    sha256 = "0a6i9pvl4lj2k1snmc5ckip86akl6c0svzmc5x0vnpl4id0f3raw";
  };

  # Alacritty

  xdg.configFile."alacritty/alacritty.yml".source =
    ../config/alacritty/alacritty.yml;

  #
  # PROGRAMS
  #

  programs.qutebrowser.enable = true;
  programs.nnn.enable = true;
  programs.feh.enable = true;
  programs.java.enable = true;
  programs.jq.enable = true;
  programs.mpv.enable = true;
  programs.afew.enable = true;
  programs.mbsync.enable = true;

  programs.waybar = { enable = true; };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.nushell = {
    enable = true;
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

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-nightly-bin;
    profiles = {
      default = {
        id = 0;
        name = "Default";
        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "extensions.webextensions.restrictedDomains" = "";

          # Use screen share indicator that works better in Wayland
          "privacy.webrtc.legacyGlobalIndicator" = false;

          # Needed to make certain key combinations work with Tridactyl
          "privacy.resistFingerprinting" = false;
          "privacy.resistFingerprinting.block_mozAddonManager" = false;
        };
      };
      private = {
        id = 1;
        name = "Private";
        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "extensions.webextensions.restrictedDomains" = "";

          # Use screen share indicator that works better in Wayland
          "privacy.webrtc.legacyGlobalIndicator" = false;

          # Needed to make certain key combinations work with Tridactyl
          "privacy.resistFingerprinting" = false;
          "privacy.resistFingerprinting.block_mozAddonManager" = false;
        };
      };
      testing = {
        id = 2;
        name = "Testing";
        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "extensions.webextensions.restrictedDomains" = "";

          # Use screen share indicator that works better in Wayland
          "privacy.webrtc.legacyGlobalIndicator" = false;

          # Needed to make certain key combinations work with Tridactyl
          "privacy.resistFingerprinting" = false;
          "privacy.resistFingerprinting.block_mozAddonManager" = false;
        };
      };
    };
  };

  programs.alacritty = { enable = true; };

  programs.kitty = { enable = true; };

  programs.git = {
    enable = true;
    userName = "dnordstrom";
    userEmail = "d@mrnordstrom.com";
    aliases = {
      co = "checkout";
      c = "commit";
      a = "commit -am";
      s = "status";
      b = "branch";
      pu = "pull";
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

    cdpath = [ "/home/dnordstrom" "/home/dnordstrom/Code" ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "sudo" ];
    };

    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "nix-shell";
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      }
    ];

    initExtra = builtins.readFile ../config/zsh/zshrc;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true; # Adds eval "$(zoxide init zsh)" to .zshrc
    # To disable alias creation on init: options = [ "--no-aliases" ];
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
  };

  # Fuzzy finder written in Rust (both sk and fzf works with fzf-lua for nvim)

  programs.skim = { enable = true; };

  # Lua alternative to z.sh for (even) faster navigation

  programs.z-lua = {
    enable = true;
    enableZshIntegration = true;
    enableAliases = false; # Disabling to try zoxide
  };

  programs.go = {
    enable = true;
    goPath = "Applications/Go";
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

  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.neomutt = {
    enable = true;
    vimKeys = true;
  };

  programs.notmuch = {
    enable = true;
    hooks = { preNew = "mbsync --all"; };
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
    # Settings are currently not working so we manage the config manually, see GH issue
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
    html.enable = true;
    json.enable = true;
    # Man pages are installed by default
  };

  #
  # SERVICES
  #

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt";
  };

  # Gnome Keyring required for ProtonMail Bridge according to package source

  services.gnome-keyring.enable = true;

  #
  # Systemd
  #

  # ProtonMail Bridge user service allowing email clients to send and receive email

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
  # ACCOUNTS
  #

  accounts.email.accounts.mrnordstrom = {
    primary = true;
    neomutt.enable = true;
    lieer.enable = true;
    notmuch.enable = true;
    mbsync.enable = true;
    mbsync.create = "both";

    realName = "Daniel Nordstrom";
    userName = "d@mrnordstrom.com";
    address = "d@mrnordstrom.com";

    imap.host = "mail.mrnordstrom.com";
    smtp.host = "mail.mrnordstrom.com";

    signature = {
      text = ''
        Daniel Nordstrom
        d@mrnordstrom.com
      '';
      showSignature = "append";
    };

    passwordCommand = "${pkgs.pass}/bin/pass home/email/d@mrnordstrom.com";
  };

  accounts.email.accounts.leeroy = {
    neomutt.enable = true;
    lieer.enable = true;
    notmuch.enable = true;
    mbsync.enable = true;
    mbsync.create = "both";

    realName = "Daniel Nordstrom";
    userName = "daniel.nordstrom@leeroy.se";
    address = "daniel.nordstrom@leeroy.se";

    imap.host = "mail.leeroy.se";
    smtp.host = "mail.leeroy.se";

    signature = {
      text = ''
        Daniel Nordstrom
        Developer
        Leeroy Group
      '';
      showSignature = "append";
    };

    passwordCommand =
      "${pkgs.pass}/bin/pass work/email/daniel.nordstrom@leeroy.se";
  };

  #
  # SECURITY
  #

  pam.yubico.authorizedYubiKeys.ids = [ "ccccccurnfle" ];
}

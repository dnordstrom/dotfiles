# USER MODULE: DNORDSTROM
#
# Author: Daniel Nordstrom <d@mrnordstrom.com>
# Repository: https://github.com/dnordstrom/dotfiles
#  
{ pkgs, nixpkgs, lib, ... }:

#  
# APPLICATIONS
#  
let
  editor = "nvim";
  browser = "firefox";
  terminal = "kitty";
  xdgEditor = [ "neovim-kitty.desktop" ];
  xdgMarkdown = [ "neovim-kitty.desktop" ];
  xdgBrowser = [ "firefox.desktop" ];
  xdgPdfViewer = [ "org.pwmt.zathura.desktop" ];
  xdgFileBrowser = [ "org.kde.dolphin.desktop" ];
  xdgImageViewer = [ "vimiv.desktop" ];
  xdgMediaPlayer = [ "org.kde.haruna.desktop" ];

  # 
  # MIME-TYPE ASSOCIATIONS 
  # 
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

  # Dependencies for some Python applications
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

  #
  # Desktop entries
  #
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = mimeAassociations;
      defaultApplications = mimeAassociations;
    };

    #
    # Terminal applications
    #

    desktopEntries = {
      neovim-alacritty = {
        name = "Neovim (Alacritty)";
        type = "Application";
        genericName = "Text Editor";
        exec = "alacritty --class popupterm -e nvim %F";
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
        exec = "kitty --class popupterm -e nvim %F";
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
        exec = "kitty --class popupterm -e vifm %F";
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
        exec = "alacritty --class popupterm -e vifm %F";
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
        exec = "kitty --class popupterm -e glow %F";
        terminal = false;
        icon = "kitty";
        categories = [ "Utility" "TextEditor" ];
        mimeType = [ "text/markdown" ];
        startupNotify = false;
      };

      #
      # Development sessions
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
      # Other applications
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

    };
  };

  #
  # PACKAGES
  #

  home.packages = with pkgs; [
    #
    # Local
    #

    nordpkgs.ayu-mirage-theme-gtk
    nordpkgs.convox
    nordpkgs.hqplayer-desktop
    nordpkgs.hydroxide
    nordpkgs.jira-cli
    nordpkgs.protoncheck
    nordpkgs.pw-volume

    #
    # Networking
    #

    enlightenment.econnman
    gnome.gnome-keyring
    haskellPackages.network-manager-tui
    krita
    libgnome-keyring
    networkmanager-openconnect
    networkmanager-openvpn
    networkmanager_dmenu
    nm-tray
    openconnect
    openvpn
    qview
    speedcrunch
    speedtest-cli
    ytmdesktop

    #
    # Nix
    #

    cachix
    nix-prefetch

    #
    # General
    #

    appimage-run
    dolphin
    element-desktop
    fractal
    gcc
    guvcview
    lynx
    nextcloud-client
    pavucontrol
    qbittorrent
    signal-desktop
    slack
    spotify
    sqlite
    tor-browser-bundle-bin
    zathura

    #
    # Command line
    #

    awscli2
    bitwarden-cli
    bottom # Resource monitor alternative to gotop
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
    unzip # Dolphin uses unzip to treat archives as directories
    usbutils # For lsusb
    vifm-full
    weechat
    xclip
    xdotool
    xorg.xev
    xsel

    #
    # Zsh plugins (sourced in `program.zsh.interactiveShellInit`)
    #

    zsh-fzf-tab
    zsh-nix-shell
    zsh-autopair

    #
    # Wayland
    #

    # layer shell, panels, and effects
    swayidle
    swaykbdd
    swaylock-effects
    swaywsr

    # Notifications
    fnott # keyboard driven notification daemon TODO: Try out

    # Screenshots
    grim
    imagemagick
    slurp
    swappy

    # Images
    vimiv-qt # QT image viewer

    # Recording and wl-clipboard
    wf-recorder
    wl-clipboard

    # Monitor
    kanshi
    wdisplays
    wlsunset

    # Launchers
    masterPackages.wofi
    rofi-calc
    rofi-emoji
    rofi-systemd
    rofi-wayland
    wofi-emoji
    workstyle

    # Input
    libinput # For trackpad gestures
    swaykbdd
    wev
    wtype
    ydotool

    #
    # UI toolkits and libraries
    #

    gnome-breeze
    gnome.dconf-editor
    gsettings-desktop-schemas
    libsForQt5.kpackage
    libsForQt5.packagekit-qt # For installing some KDE services
    packagekit

    #
    # Office 
    #

    # Fresh is the possibly unstable newer build, otherwise use libreoffice-qt or libreoffice-still
    libreoffice-fresh

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

    bitwarden
    mozwire
    go-2fa
    pinentry-gtk2
    protonvpn-cli
    qtpass

    #
    # Multimedia
    #

    alsa-firmware
    alsa-tools
    alsa-utils
    audacious
    carla
    cava
    celluloid # GTK frontend for MPV
    easyeffects
    handbrake
    haruna # QT frontend for MPV
    pulseaudio
    pulsemixer
    spicetify-cli
    spotify-qt
    spotify-tui
    spotifyd
    strawberry
    lxqt.pavucontrol-qt

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

    # Editors
    jetbrains.goland
    jetbrains.idea-ultimate
    jetbrains.webstorm
    libsForQt5.kate

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

    #
    # Appearance
    #

    # Fonts
    corefonts
    fontforge
    jetbrains-mono
    line-awesome
    powerline-fonts
    victor-mono
    fcft # Font loading library used by foot

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
    flashfocus
    gtk-engine-murrine
    gtk_engines
    icoutils
    libsForQt5.qtcurve
    lxappearance
    masterPackages.themechanger
    qt5ct

    # Themes
    nordic # GTK, QT, and Kvantum
    lightly-qt
    libsForQt5.grantleetheme
    lxqt.lxqt-themes
    zuki-themes
    masterPackages.ayu-theme-gtk
    dracula-theme
    arc-icon-theme
    paper-icon-theme
    papirus-icon-theme
    flat-remix-icon-theme
    moka-icon-theme # Fallback for Arc icon theme
    vimix-icon-theme
    vimix-gtk-themes
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
    interception-tools # and caps2esc plugin, for intercepting at device level instead of WM
    corgi # CLI workflow manager
    navi # CLI cheatsheet tool
    tealdeer # TLDR in Rust
    tmpmail # CLI temporary email generator
    httpie # HTTP client, simpler alternative to cURL
    curlie # HTTP client, simpler alternative to cURL
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
    wezterm
    cawbird # Twitter client
    bottles

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
    systemdIntegration = true;

    wrapperFeatures = {
      base = true;
      gtk = true;
    };

    extraSessionCommands = ''
      # Firefox
      export MOZ_ENABLE_WAYLAND=1
      export MOZ_USE_XINPUT2=1

      # Wayland
      export QT_QPA_PLATFORM=wayland
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

      # Styling
      export QT_QPA_PLATFORMTHEME=qt5ct
      unset QT_STYLE_OVERRIDE
    '';
  };

  #
  # QT
  #

  qt = {
    enable = true;
    # These do not seem to set the correct environment variables for qt5ct:
    # platformTheme = "gtk";
    # style = { name = "qt5ct-style"; };
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
    theme.name = "Ayu-Dark";
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

  # Secrets

  home.file.".env".source = ../secrets/env;

  # Scripts

  home.file.".scripts".source = ../scripts;

  # EasyEffects

  xdg.configFile."easyeffects".source = ../config/easyeffects;

  # Sway

  xdg.configFile."sway".source = ../config/sway;
  xdg.configFile."swaylock/config".source = ../config/swaylock/config;
  xdg.configFile."swaynag/config".source = ../config/swaynag/config;

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

  # Foot

  xdg.configFile."foot".source = ../config/foot;

  #
  # PROGRAMS
  #

  programs.foot = {
    enable = true;
    server.enable = true;
  };

  programs.qutebrowser.enable = true;
  programs.nnn.enable = true;
  programs.feh.enable = true;
  programs.java.enable = true;
  programs.jq.enable = true;
  programs.mpv.enable = true;
  programs.afew.enable = true;
  programs.mbsync.enable = true;
  programs.waybar.enable = true;

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
    package = pkgs.latest.firefox-nightly-bin;
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

    dirHashes = {
      bak = "$HOME/Backup";
      docs = "$HOME/Documents";
      shots = "$HOME/Pictures/Screenshots";
      dl = "$HOME/Downloads";
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
        name = "sudo";
        src = pkgs.fetchgit {
          url = "https://github.com/ohmyzsh/ohmyzsh";
          rev = "957dca698cd0a0cafc6d2551eeff19fe223f41bd";
          sparseCheckout = "plugins/sudo";
          sha256 = "sha256-iM8wFFIfDZIVyGvscoxxGyD38iOiQXYmagrhRo0ig9U=";
        };
        file = "sudo.plugin.zsh";
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

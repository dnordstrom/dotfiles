# USER MODULE: DNORDSTROM
#
# Author: Daniel Nordstrom <d@mrnordstrom.com>
# Repository: https://github.com/dnordstrom/dotfiles
#  
{ pkgs, nixpkgs, lib, config, ... }:

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
  xdgHttpie = [ "httpie.desktop" ];

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
    "x-scheme-handler/pie" = xdgHttpie;
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
      httpie = {
        name = "HTTPie";
        type = "Application";
        genericName = "Modern HTTP client for the API era";
        exec =
          "appimage-run /home/dnordstrom/Applications/httpie/HTTPie-2022.7.0.AppImage %F";
        terminal = false;
        icon = "httpie";
        categories = [ "Utility" "Development" ];
        mimeType = [ "x-scheme-handler/pie" ];
        startupNotify = false;
      };
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

    nordpkgs.convox

    #
    # Networking
    #

    gnome.gnome-keyring
    haskellPackages.network-manager-tui
    libgnome-keyring
    nm-tray
    openvpn
    ytmdesktop

    #
    # Nix
    #

    agenix
    cachix
    nix-prefetch

    #
    # General
    #

    appimage-run
    dmg2img
    dolphin
    element-desktop
    ferdi
    fractal
    gcc
    pavucontrol
    qbittorrent
    signal-desktop
    slack
    tor-browser-bundle-bin
    woeusb-ng
    zathura

    #
    # Command line
    #

    awscli2
    bitwarden-cli
    bottom
    fd
    gh
    glow
    gotktrix
    libnotify
    matrixcli
    onefetch # Git summary
    neofetch # System summary
    parallel
    rdrview # URL article viewer based on Firefox's Readability
    ripgrep
    tree
    unzip
    usbutils
    vifm-full
    weechat
    xclip
    xdotool
    xsel

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
    swayidle
    swaykbdd
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

    # Fresh is the possibly unstable newer build, otherwise use libreoffice-qt or libreoffice-still
    libreoffice-fresh

    #
    # Web browsing
    #

    tridactyl-native # Firefox native messaging host

    #
    # Email
    #

    electron-mail

    #
    # Security
    #

    bitwarden
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
    deadbeef-with-plugins
    handbrake
    haruna # QT frontend for MPV
    nordpkgs.hqplayer-desktop
    jamesdsp
    pulseaudio
    pulsemixer

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

    # Git
    bfg-repo-cleaner

    # Nix
    nixfmt # Opinionated formatter, used by null-ls
    nixpkgs-fmt # Another formatter
    nixpkgs-lint
    nixos-option
    statix # Static analysis

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

    #
    # Appearance
    #

    # Fonts
    corefonts
    jetbrains-mono
    powerline-fonts
    victor-mono
    fcft # Font loading library used by foot

    # Qt libs
    libsForQt5.ark
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
    lxappearance

    # Themes
    vimix-icon-theme
    quintom-cursor-theme

    #
    # Interesting prospects
    #

    swayr
    quaternion
    neochat
    gomuks
    gotktrix
    fluffychat
    etcher
    mdcat
    interception-tools # and caps2esc plugin, for intercepting at device level instead of WM
    corgi # CLI workflow manager
    navi # CLI cheatsheet tool
    tealdeer # TLDR in Rust
    tmpmail # CLI temporary email generator
    httpie # HTTP client, simpler alternative to cURL
    curlie # HTTP client, simpler alternative to cURL
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
    krusader
    git-crypt
    jetbrains.datagrip
    wezterm
    bottles
    pro-office-calculator

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
      size = 8;
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

  # Secrets

  home.file.".env".source = /run/agenix/env;

  # Scripts

  home.file.".scripts".source = ../scripts;

  # Wallpapers

  home.file."Pictures/Wallpapers".source = ../wallpapers;

  # EasyEffects
  #
  #   Settings directories are writable but presets direcotory read-only. This allows EasyEffects
  #   to modify its settings while the presets are immutable since that's where the important
  #   presets are saved.

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

  # Zathura

  xdg.configFile."zathura".source = ../config/zathura;

  # Firefox

  xdg.configFile."tridactyl".source = ../config/firefox/tridactyl;

  home.file.".mozilla/native-messaging-hosts/tridactyl.json".source =
    "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";

  # Neovim

  xdg.configFile."nvim/lua".source = ../config/nvim/lua;
  xdg.configFile."nvim/ftplugin".source = ../config/nvim/ftplugin;
  xdg.configFile."nvim/luasnippets".source = ../config/nvim/luasnippets;

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

  programs.waybar = {
    enable = true;
    systemd.target = "sway-session.target";
  };

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

  programs.firefox = let
    config = {
      # Disable annoyances
      "browser.aboutConfig.showWarning" = false;
      "browser.bookmarks.restore_default_bookmarks" = false;
      "browser.shell.checkDefaultBrowser" = false;
      "extensions.webextensions.restrictedDomains" = "";

      # Enable userChrome.css and userContent.css
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

      # Enable legacy screen share indicator that works better in Wayland
      "privacy.webrtc.legacyGlobalIndicator" = false;

      # Needed to make certain key combinations work with Tridactyl
      "privacy.resistFingerprinting" = false;
      "privacy.resistFingerprinting.block_mozAddonManager" = false;
    };
  in {
    enable = true;
    package = pkgs.latest.firefox-nightly-bin;
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

  services.gnome-keyring.enable = true;

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

  services.easyeffects.enable = true;

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

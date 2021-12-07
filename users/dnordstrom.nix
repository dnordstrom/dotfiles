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
    "application/xhtml+xml" = xdgBrowser;
    "application/x-extension-htm" = xdgBrowser;
    "application/x-extension-html" = xdgBrowser;
    "application/x-extension-shtml" = xdgBrowser;
    "application/x-extension-xhtml" = xdgBrowser;
    "application/x-extension-xht" = xdgBrowser;
  };
in
{
  #
  # Modules
  #

  imports = [ ../modules/vscode.nix ];

  #
  # Environment
  #

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
        exec = "slack --enable-features=UseOzonePlatform --ozone-platform=wayland -s %U";
        terminal = false;
        icon = "slack";
        categories = [ "GNOME" "GTK" "Network" "InstantMessaging" ];
        mimeType = [ "x-scheme-handler/slack" ];
        startupNotify = true;
      };
    };
  };

  #
  # Packages
  #

  home.packages = with pkgs; [
    # Nix
    cachix

    # Connections
    networkmanager_dmenu

    # General
    appimage-run
    element-desktop
    fractal
    gcc
    guvcview
    kate
    nextcloud-client
    pavucontrol
    pinentry
    pinentry-curses
    pulseaudio # For pactl since pw-cli makes me cry
    qbittorrent
    signal-desktop
    slack
    spotify
    sqlite
    tor-browser-bundle-bin
    zathura

    # Command line
    arcan.espeak
    asciinema # For asciinema.org
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

    # Zsh (sourced in program.zsh.interactiveShellInit)
    zsh-fzf-tab
    zsh-nix-shell

    # Sway and Wayland specific
    fnott
    grim
    imagemagick
    imv # Command line image viewer
    libinput # For trackpad gestures
    nwg-drawer
    nwg-launchers
    nwg-menu
    nwg-panel
    nwg-panel
    slurp
    swayidle
    swaylock-effects
    swaywsr
    vimiv-qt # QT image viewer
    wdisplays
    wev
    wf-recorder
    wl-clipboard
    wlogout
    wofi
    wofi-emoji
    workstyle
    wtype
    ydotool

    # Gnome
    gnome-breeze
    gnomeExtensions.gsconnect
    peek

    # Web browsing
    tridactyl-native # Firefox native messaging host
    luakit # GTK, WebKit, Lua

    # Email
    bitwarden # Password manager
    electron-mail # ProtonMail client
    hydroxide # ProtonMail bridge
    protonmail-bridge # ProtonMail bridge

    # Security
    yubikey-manager-qt

    # Multimedia
    celluloid
    handbrake
    haruna
    smplayer
    sayonara

    #
    # Development
    #

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

    # Shell
    shfmt
    shellharden

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
    line-awesome
    powerline-fonts

    # Qt libs
    libsForQt5.qqc2-breeze-style
    libsForQt5.breeze-gtk
    libsForQt5.breeze-qt5
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.networkmanager-qt
    libsForQt5.akonadi-contacts
    libsForQt5.kaccounts-integration
    libsForQt5.kcontacts
    libsForQt5.kaccounts-providers
    libsForQt5.kdeconnect-kde
    libsForQt5.kio-gdrive
    libsForQt5.parachute
    libsForQt5.qt5.qtwayland
    libsForQt5.qtcurve
    qgnomeplatform

    # Theming tools
    masterPackages.themechanger
    qt5ct

    # Themes
    nordic # GTK, QT, and Kvantum
    masterPackages.ayu-theme-gtk
    qogir-theme
    adwaita-qt

    # Icons
    arc-icon-theme
    numix-icon-theme-circle
    paper-icon-theme
    papirus-icon-theme
    pop-icon-theme
    flat-remix-icon-theme
    tela-icon-theme
    qogir-icon-theme
    moka-icon-theme # Fallback for Arc icon theme

    # Cursors
    numix-cursor-theme
    quintom-cursor-theme
    bibata-cursors
    bibata-cursors-translucent

    #
    # Custom from ./packages
    #

    convox
    jira-cli

    #
    # Remember to try out
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
    natls
    exa
    lsd
  ];

  #
  # Sway
  #

  wayland.windowManager.sway = {
    enable = true;
    config = null;
    extraConfig = builtins.readFile ../config/sway/config;
    extraSessionCommands = ''
      export GDK_BACKEND=wayland
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export QT_QPA_PLATFORMTHEME=gtk2
      export QT_STYLE_OVERRIDE=kvantum-dark
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export SDL_VIDEODRIVER=wayland
      export XDG_CURRENT_DESKTOP=sway
      export XDG_SESSION_DESKTOP=sway
      export XDG_SESSION_TYPE=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

  #
  # Qt
  #

  qt = {
    enable = true;
    platformTheme = "gtk";
    style = { name = "kvantum-dark"; };
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
    theme.name = "Nordic";
    iconTheme.name = "Papirus-Dark";
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = "true";
      extraCss = "";
    };
    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = "true"
    '';
  };

  #
  # Configuration files
  #

  # Scripts

  home.file.".scripts".source = ../scripts;

  # Sway

  xdg.configFile."swaylock/config".source = ../config/swaylock/config;
  xdg.configFile."swaynag/config".source = ../config/swaynag/config;

  xdg.configFile."sway/colors.ayu".source = ../config/sway/colors.ayu;
  xdg.configFile."sway/colors.ayu-mirage".source =
    ../config/sway/colors.ayu-mirage;
  xdg.configFile."sway/colors.ayu-dark".source = ../config/sway/colors.ayu-dark;
  xdg.configFile."sway/colors.nord".source = ../config/sway/colors.nord;

  # Kitty

  xdg.configFile."kitty".source = ../config/kitty;

  # tmux

  xdg.configFile."tmux".source = ../config/tmux;

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

  xdg.configFile."wofi/config".source = ../config/wofi/config;
  xdg.configFile."wofi/style.css".source = ../config/wofi/style.css;

  # Waybar

  xdg.configFile."waybar/config".source = ../config/waybar/config;
  xdg.configFile."waybar/style.css".source = ../config/waybar/style.css;

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
  # Programs
  #

  programs.waybar.enable = true;
  programs.qutebrowser.enable = true;
  programs.feh.enable = true;
  programs.jq.enable = true;
  programs.mpv.enable = true;
  programs.password-store.enable = true;
  programs.afew.enable = true;
  programs.mbsync.enable = true;

  programs.firefox = {
    enable = true;
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
    userName = "dnordstrom";
    userEmail = "d@mrnordstrom.com";
    aliases = {
      co = "checkout";
      ci = "commit";
      cia = "commit --amend";
      s = "status";
      st = "status";
      b = "branch";
      p = "pull --rebase";
      pu = "push";
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
      theme = "agnoster";
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

  programs.tmux = { enable = true; };

  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
      style = "numbers,rule";
    };
  };

  # Fuzzy finder written in Go
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Fuzzy finder written in Rust (both sk and fzf works with fzf-lua for nvim)
  programs.skim = {
    enable = true;
  };

  # Lua alternative to z.sh for (even) faster navigation
  programs.z-lua = {
    enable = true;
    enableZshIntegration = true;
    enableAliases = true;
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
    backgroundColor = "#434C5E";
    borderColor = "#E5E9F0BB";
    borderRadius = 0;
    borderSize = 2;
    defaultTimeout = 5000;
    enable = true;
    font = "sans 9";
    height = 110;
    icons = true;
    ignoreTimeout = false;
    layer = "overlay";
    margin = "20";
    markup = true;
    maxIconSize = 24;
    padding = "12";
    sort = "-time";
    textColor = "#E5E9F0";
    width = 300;
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
    # To add feeds:
    # urls = [
    #   {
    #     tags = [ "foo" "bar" ];
    #     url = "http://example.com";
    #   }
    # ];
  };

  programs.gpg = { enable = true; };

  #
  # Services
  #

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  #
  # Email accounts
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
}

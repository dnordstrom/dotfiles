{ pkgs, nixpkgs, lib, ... }:

{
  #
  # Modules
  #

  imports = [
    ../modules/vscode.nix
  ];

  #
  # General
  #

  xdg = {
    enable = true;
    desktopEntries = {
      neovim-alacritty = {
        name = "Neovim";
        genericName = "Text Editor";
        exec = "alacritty --class terminal --title terminal -e nvim %U";
        terminal = false;
        icon = "neovim";
        categories = [ "Development" "TextEditor" ];
        mimeType = [ "text/plain" ];
      };
      vifm-alacritty = {
        name = "Vifm (Alacritty)";
        genericName = "File Manager";
        exec = "alacritty --class terminal --title terminal -e vifm %U";
        terminal = false;
        icon = "vifm";
        categories = [ "System" "FileManager" ];
        mimeType = [ "text/plain" ];
      };
    };
  };

  #
  # Packages
  #

  home.packages =
  let
    convox = pkgs.callPackage ../packages/convox.nix {};
    jira-cli = pkgs.callPackage ../packages/jira-cli.nix {};
  in
  with pkgs; [
    # General
    appimage-run
    bitwarden
    electron-mail
    element-desktop
    fractal
    gcc
    guvcview
    kate
    nextcloud-client
    pavucontrol
    pinentry
    pinentry-curses
    protonmail-bridge
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
    nixpkgs-fmt
    parallel
    ripgrep
    shfmt
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

    # Desktop integration portals
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-kde
    xdg-desktop-portal-gtk

    # Sway and Wayland specific
    fnott
    grim
    imagemagick
    libsForQt5.qt5.qtwayland
    nwg-drawer
    nwg-launchers
    nwg-menu
    nwg-panel
    nwg-panel
    qt5ct
    slurp
    swayidle
    swaylock-effects
    swaywsr
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

    # Plasma
    libsForQt5.akonadi-contacts
    libsForQt5.breeze-gtk
    libsForQt5.breeze-qt5
    libsForQt5.kaccounts-integration
    libsForQt5.kcontacts
    libsForQt5.kaccounts-providers
    libsForQt5.kdeconnect-kde
    libsForQt5.kio-gdrive
    libsForQt5.parachute
    libsForQt5.plasma-applet-virtual-desktop-bar

    # Gnome
    gnome-breeze
    gnomeExtensions.gsconnect
    peek

    # Web browsing
    tridactyl-native
    luakit
    vieb
    vimb

    # Multimedia
    celluloid
    haruna
    smplayer
    sayonara

    # Tryouts
    quaternion
    nheko
    neochat

    # LSP and language tools
    gopls
    luajit
    nodePackages.bash-language-server
    nodePackages.diagnostic-languageserver
    nodePackages.eslint
    nodePackages.eslint_d
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.vim-language-server
    nodePackages.vscode-langservers-extracted # HTML, CSS, and JSON
    nodePackages.yaml-language-server
    tree-sitter
    vgo2nix


    # Font related
    corefonts
    fontforge
    line-awesome
    powerline-fonts

    # Themes
    nordic

    # Icons
    arc-icon-theme
    numix-icon-theme-circle
    paper-icon-theme
    papirus-icon-theme
    pop-icon-theme
    tela-icon-theme

    # Custom
    convox
    jira-cli

    # Remember to try out
    swayr
  ];

  #
  # Sway
  #

  wayland.windowManager.sway = {
    enable = true;
    config = null; # Remove default config since we provide our own
    extraConfig = builtins.readFile ../config/sway/config;
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
      export GDK_BACKEND=wayland
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export QT_QPA_PLATFORMTHEME=qt5ct
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export SDL_VIDEODRIVER=wayland
      export XDG_CURRENT_DESKTOP=sway
      export XDG_SESSION_DESKTOP=sway
      export XDG_SESSION_TYPE=wayland
    '';
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
    iconTheme = {
      package = pkgs.numix-icon-theme-circle;
      name = "Numix Circle";
    };
    theme = {
      package = pkgs.nordic;
      name = "Nordic-v40";
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = "true";
    };
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
  xdg.configFile."sway/colors.ayu-mirage".source = ../config/sway/colors.ayu-mirage;
  xdg.configFile."sway/colors.ayu-dark".source = ../config/sway/colors.ayu-dark;
  xdg.configFile."sway/colors.nord".source = ../config/sway/colors.nord;

  # tmux

  home.file.".tmux.conf".source = ../config/tmux/tmux.conf;

  # Firefox

  xdg.configFile."tridactyl".source = ../config/firefox/tridactyl;

  home.file.".mozilla/native-messaging-hosts/tridactyl.json".source = "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";

  # Neovim

  xdg.configFile."nvim/lua".source = ../config/nvim/lua;
  xdg.configFile."nvim/ftplugin".source = ../config/nvim/ftplugin;

  # Vifm

  xdg.configFile."vifm".source = ../config/vifm;

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
    url = "https://github.com/arcticicestudio/nord-dircolors/releases/download/v0.2.0/dir_colors";
    sha256 = "0a6i9pvl4lj2k1snmc5ckip86akl6c0svzmc5x0vnpl4id0f3raw";
  };

  # Alacritty

  xdg.configFile."alacritty/alacritty.yml".source = ../config/alacritty/alacritty.yml;

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

  programs.alacritty = {
    enable = true;
  };

  programs.git = {
    userName  = "dnordstrom";
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
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = builtins.readFile ../config/nvim/init.vim;
  };

  programs.zsh = {
    autocd = true;
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;

    cdpath = [
      "/home/dnordstrom"
      "/home/dnordstrom/Code"
    ];

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins =  [ "sudo" ];
    };

    initExtra = builtins.readFile ../config/zsh/zshrc;
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    sensibleOnTop = true;
    shortcut = "a";
    terminal = "screen-256color";
    secureSocket = false;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
      style = "numbers,rule";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.go = {
    enable = true;
    goPath = "Applications/Go";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    nix-direnv.enableFlakes = true;
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
    hooks = {
      preNew = "mbsync --all";
    };
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

  programs.gpg = {
    enable = true;
  };

  #
  # Services
  #

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "curses";
    # extraConfig = ''
    #   pinentry-program ${pkgs.pinentry-curses}/bin/pinentry-curses
    # '';
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

    realName= "Daniel Nordstrom";
    userName= "d@mrnordstrom.com";
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

    realName= "Daniel Nordstrom";
    userName= "daniel.nordstrom@leeroy.se";
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

    passwordCommand = "${pkgs.pass}/bin/pass work/email/daniel.nordstrom@leeroy.se";
  };

  #
  # Environment
  #

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}

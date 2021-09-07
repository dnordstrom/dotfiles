{ pkgs, nixpkgs, ... }:

{
  #
  # Modules
  #

  imports = [
    ../modules/vscodium.nix
  ];

  #
  # General
  #

  xdg.enable = true;

  #
  # Packages
  #

  home.packages =
  let
    convox = pkgs.callPackage ../packages/convox.nix {};
  in
  with pkgs; [
    # Programs
    bitwarden
    bitwarden-cli
    bustle # GTK-based D-Bus inspector
    dfeet # GTK-based D-Bus inspector
    element-desktop
    fd
    fractal
    guvcview
    ideogram # From ElementaryOS, while Plasma's emoji picker doesn't work
    kate
    libnotify
    qbittorrent
    quaternion
    ripgrep
    shfmt
    signal-desktop
    slack
    sqlite
    tor-browser-bundle-bin
    usbutils # For `lsusb`
    weechat
    weechatScripts.wee-slack
    weechatScripts.weechat-matrix
    weechatScripts.weechat-notify-send
    xdotool

    # Desktop integration portals
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-kde
    xdg-desktop-portal-gtk

    # Sway
    fnott
    grim
    libsForQt5.qt5.qtwayland
    nwg-drawer
    nwg-launchers
    nwg-menu
    nwg-panel
    nwg-panel
    slurp
    swayidle
    swaylock
    wl-clipboard
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

    # Display manager
    greetd.tuigreet

    # Browser tools
    chrome-gnome-shell
    plasma-browser-integration
    tridactyl-native

    # Multimedia
    celluloid
    haruna
    smplayer

    # Tryouts
    quaternion # Matrix client
    nheko # Matrix client
    neochat # Matrix client
    weechat
    weechatScripts.wee-slack
    weechatScripts.weechat-matrix

    # NPM packages
    nodePackages.bash-language-server
    nodePackages.eslint
    nodePackages.diagnostic-languageserver
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted # HTML, CSS, and JSON
    nodePackages.yaml-language-server

    # Language servers
    gopls

    # Fonts
    corefonts
    input-fonts
    powerline-fonts

    # Themes
    arc-kde-theme
    arc-theme
    nordic

    # Icon themes
    numix-icon-theme-circle

    # Unnecessary utilities
    neo-cowsay
    fortune
    lolcat
    toilet

    # Custom packages
    convox
  ];

  #
  # Sway
  #

  xdg.configFile."swaylock/config".source = ../config/swaylock/config;

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraConfig = builtins.readFile ../config/sway/config;
    extraSessionCommands = ''
      export GDK_BACKEND=wayland
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

  #
  # Firefox
  #

  xdg.configFile."tridactyl/tridactylrc".source = ../config/firefox/tridactylrc;

  home.file.".mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";
  home.file.".mozilla/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source = "${pkgs.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";
  home.file.".mozilla/native-messaging-hosts/tridactyl.json".source = "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";

  programs.firefox = {
    enable = true;
    extensions =
      with pkgs.nur.repos.rycee.firefox-addons; [
        # Using Firefox Sync for extensions
      ];
  };

  #
  # Alacritty
  #

  xdg.configFile."alacritty/alacritty.yml".source = builtins.toFile "alacritty.yml" (
    builtins.readFile (
      builtins.fetchurl {
        url = "https://raw.githubusercontent.com/arcticicestudio/nord-alacritty/d4b6d2049157a23958dd0e7ecc4d18f64eaa36f3/src/nord.yml";
        sha256 = "0adp4v2d5w6j4j2lavgwbq2x8gnvmxk4lnmlrvl9hy62rxrqp561";
      }) + ''

      font:
        normal:
          family: 'Iosevka Nerd Font'
        bold:
          family: 'Iosevka Nerd Font'
        italic:
          family: 'Iosevka Nerd Font'
        bold_italic:
          family: 'Iosevka Nerd Font'
        size: 10
        offset:
          x: 0
          y: 0
        glyph_offset:
          x: 0
          y: 0
      window:
        padding:
          x: 12
          y: 8
        dynamic_padding: false
      background_opacity: 0.98
    ''
  );
  
  # Use offset y 4 and glyph_offset 4 if it looks weird, depending on font used

  programs.alacritty = {
    enable = true;
  };

  #
  # GTK
  #

  gtk = {
    enable = true;
    font.name = "Noto Sans 10";
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
  # Git
  #

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

  #
  # Chromium
  #

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

  #
  # Neovim
  #

  xdg.configFile."nvim/lua".source = ../config/nvim/lua;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = "lua require('init')";
    plugins = with pkgs.vimPlugins; [
      dashboard-nvim
      lualine-nvim
      luasnip
      nerdcommenter
      nerdtree
      nord-nvim
      numb-nvim
      nvim-autopairs
      nvim-compe
      nvim-lspconfig
      nvim-treesitter
      nvim-web-devicons
      telescope-frecency-nvim
      telescope-fzf-native-nvim
      telescope-nvim
      telescope-symbols-nvim
      trouble-nvim
      vim-javascript
      vim-markdown
      vim-nix
      vim-surround
      {
        plugin = sql-nvim;
        config = "let g:sql_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'";
      }
    ];
  };

  #
  # ZSH and Plugins
  #

  programs.zsh = {
    autocd = true;
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;

    cdpath = [
      "/etc/nixos"
      "/home/dnordstrom/Code"
      "/home/dnordstrom/Code/ticker"
      "/home/dnordstrom/Code/ticker-backend"
      "/home/dnordstrom/Code/scripts"
    ];

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins =  [ "sudo" ];
    };

    shellAliases = {
      ll = "ls -Al";
      nixkate = "kate /etc/nixos";
      nixcode = "codium /etc/nixos";
      nixvim = "nvim /etc/nixos";
      nixswitch = "sudo nixos-rebuild switch --flake /etc/nixos";
    };

    initExtra = ''
      # Prepend list item to notes
      note() {
        echo "$(echo "- $@"; cat ~/.notes.md)" > ~/.notes.md
      }
    '';
  };

  #
  # Other
  #

  # A flying `cat`
  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
      style = "numbers,rule";
    };
  };

  # Fuzzy finder
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Qutebrowser
  programs.qutebrowser.enable = true;

  # Direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    nix-direnv.enableFlakes = true;
  };

  # Mako notification daemon
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

  # Dircolors terminal `LS_COLOR` manager

  home.file.".dir_colors".source = builtins.fetchurl {
    url = "https://github.com/arcticicestudio/nord-dircolors/releases/download/v0.2.0/dir_colors";
    sha256 = "0a6i9pvl4lj2k1snmc5ckip86akl6c0svzmc5x0vnpl4id0f3raw";
  };

  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };

  # Image viewer
  programs.feh.enable = true;

  # Alternative terminal
  programs.foot.enable = true;

  # Command line JSON parser
  programs.jq.enable = true;

  # Video player
  programs.mpv.enable = true;

  #
  # Environment
  #

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}

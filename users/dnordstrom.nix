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

  xdg.enable = true;

  #
  # Packages
  #

  home.packages =
  let
    convox = pkgs.callPackage ../packages/convox.nix {};
  in
  with pkgs; [
    # General
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
    pavucontrol
    pulseaudio # Just to get `pactl` since `pw-cli` is too complicated
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
    xorg.xev # Keyboard event viewer
    xdotool

    # Command line
    glow
    t-rec

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
    qt5ct
    slurp
    swayidle
    swaylock-effects
    swaywsr
    wdisplays # GUI display manager
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

    # Display manager
    greetd.tuigreet

    # Browser tools
    chrome-gnome-shell
    plasma-browser-integration
    tridactyl-native

    # Multimedia
    celluloid # GTK frontend for MPV
    haruna # QT frontend for MPV
    smplayer # QT frontend for MPV
    sayonara

    # Tryouts
    quaternion # Matrix client
    nheko # Matrix client
    neochat # Matrix client

    # NPM packages
    nodePackages.bash-language-server
    nodePackages.eslint
    nodePackages.diagnostic-languageserver
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted # HTML, CSS, and JSON
    nodePackages.yaml-language-server

    # Lua
    luajit

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
    arcan.espeak
    neo-cowsay
    figlet
    fortune
    lolcat
    toilet

    # Custom packages
    convox
  ];

  #
  # Scripts
  #

  home.file.".scripts".source = ../scripts;

  #
  # Sway
  #

  xdg.configFile."swaylock/config".source = ../config/swaylock/config;
  xdg.configFile."swaynag/config".source = ../config/swaynag/config;

  xdg.configFile."sway/colors.ayu".source = ../config/sway/colors.ayu;
  xdg.configFile."sway/colors.ayu-mirage".source = ../config/sway/colors.ayu-mirage;
  xdg.configFile."sway/colors.ayu-dark".source = ../config/sway/colors.ayu-dark;
  xdg.configFile."sway/colors.nord".source = ../config/sway/colors.nord;

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
        # Using Firefox Sync for addons but they can also be managed here, see:
        # https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/generated-firefox-addons.nix
      ];
  };

  #
  # Alacritty
  #

  programs.alacritty = {
    enable = true;
  };

  # Create configuration file by downloading the contents of the Nord theme and
  # appending our own options to it.
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

  xdg.configFile."nvim/lua/init.lua".source = ../config/nvim/lua/init.lua;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      lua require("init")
    '';
    plugins = with pkgs.vimPlugins; [
      chadtree
      dashboard-nvim
      friendly-snippets
      glow-nvim
      lualine-nvim
      luasnip
      ncm2
      ncm2-bufword
      ncm2-cssomni
      ncm2-neosnippet
      ncm2-path
      ncm2-syntax
      nerdcommenter
      nord-nvim
      numb-nvim
      nvim-autopairs
      nvim-lspconfig
      nvim-treesitter
      nvim-web-devicons
      nvim-yarp
      packer-nvim
      telescope-frecency-nvim
      telescope-fzf-native-nvim
      telescope-nvim
      telescope-symbols-nvim
      todo-comments-nvim
      trouble-nvim
      typescript-vim
      vim-javascript
      vim-jsx-typescript
      vim-markdown
      vim-nix
      vim-surround

      # Plugins requiring setup
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
      "/home"
      "/home/dnordstrom/Code"
    ];

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins =  [ "sudo" ];
    };


    shellAliases = {
      ll = "ls -lah"; # Same as built-in `l` (muscle memory reasons)
      cat = "bat"; # For syntax highlighting

      # Open Nix configuration in various editors with `/etc/nixos` working dir
      cdnix = "cd /etc/nixos"; cdn = "cdnix";
      nixkate = "nixwith kate";
      nixcode = "nixwith codium";
      nixvim = "nixwith vim";

      # Nix
      nixswitch-pre = "rm /home/dnordstrom/.gtkrc-2.0";
      nixswitch = "nixswitch-pre; sudo nixos-rebuild switch --flake /etc/nixos --upgrade; nixswitch-post";
      nixswitch-post = "";
      nb = "nixswitch";
    };

    initExtra = ''
      #
      # Variables
      #

      export NOTES_FILE="$HOME/.notes.md"
      export NOTES_EDITOR="$EDITOR"
      export NOTES_VIEWER="glow -p"

      #
      # Notes
      #

      view-notes() {
        eval "${NOTES_VIEWER:-cat} $NOTES_FILE"
      }

      edit-notes() {
        eval "${NOTES_EDITOR:-$EDITOR} $NOTES_FILE"
      }

      prepend-note() {
        local note="${@:-$BUFFER}"

        if ! [ -z "$note" ]; then
          backup-notes
          printf "- $note\n$(cat "$NOTES_FILE")" > "$NOTES_FILE"
          [ $# -eq 0 ] && zle kill-whole-line
        fi
      }

      backup-notes() {
        cp --backup=numbered "$NOTES_FILE" "$NOTES_FILE.$(date +%Y%m%d)"
      }

      clear-backup-notes() {
        rm $NOTES_FILE.*.*
      }

      #
      # Scripting
      #

      append-to-history() {
        fc -R =(printf "%s\n" "$@")
      }

      await-any-key() {
        printf "%s" "${*:-Press any key to continue...}"
        read -ks
      }

      await-confirm() {
        local prompt="${*:-Would you like to continue?} [Y/n] "
        local output="false"
        local code=1

        read -qs "key?$prompt"
        code=$?
        [ $code -eq 0 ] && output="true"

        printf "%s" "$output"
        return $code
      }

      await-enter-key() {
        printf "%s" "${*:-Press ENTER to continue...}"

        # Simply `read -s` works as well, if delimiter is newline
        while read -ks key; do
          [ "$key" = $'\x0a' ] && break
        done
      }

      await-string-input() {
        printf "%s " "${*:->}"
        read input
        printf "%s" "$input"
      }

      to-lowercase() {
        printf "%s" "$(printf "%s" "$*" | tr '[:upper:]' '[:lower:]')"
      }

      to-uppercase() {
        printf "%s" "$(printf "%s" "$*" | tr '[:lower:]' '[:upper:]')"
      }

      #
      # Commands
      #

      # Run command in specified directory then return (use with care)
      runindir() {
        if ! [ $# -eq 2 ]; then
          echo "Expected 2 arguments."
          echo
          echo "Usage: $0 \"~/my_dir\" \"echo someting\""
          echo
          echo "Note that both arguments are quoted."
          return 1
        fi

        local prev_dir=$(pwd)
        local dir="$(realpath $1)"; shift
        local cmd="$*"

        cd "$dir"
        eval "$cmd"
        cd "$prev_dir"
      }

      # Open Nix configuration directory with specified app
      nixwith() {
        if ! [ $# -eq 1 ]; then
          echo "Expected a single argument."
          return 1
        fi

        runindir "/etc/nixos" "$1"
      }

      #
      # Widgets
      #

      zle -N view-notes
      zle -N prepend-note
      zle -N edit-notes
      zle -N backup-notes
      zle -N clear-backup-notes

      #
      # Key Binds
      #

      bindkey "^[s" sudo-command-line
      bindkey "^[e" edit-notes
      bindkey "^[E" prepend-note
      bindkey "^[^E" view-notes
    '';
  };

  #
  # Miscellaneous
  #

  # Wofi launcher configuration
  xdg.configFile."wofi/config".source = ../config/wofi/config;
  xdg.configFile."wofi/style.css".source = ../config/wofi/style.css;

  # Status bar
  programs.waybar.enable = true;

  xdg.configFile."waybar/config".source = ../config/waybar/config;
  xdg.configFile."waybar/style.css".source = ../config/waybar/style.css;

  # Power menu
  xdg.configFile."wlogout/layout".source = ../config/wlogout/layout;
  xdg.configFile."wlogout/style.css".source = ../config/wlogout/style.css;
  xdg.configFile."wlogout/lock.png".source = ../config/wlogout/lock.png;
  xdg.configFile."wlogout/logout.png".source = ../config/wlogout/logout.png;
  xdg.configFile."wlogout/reboot.png".source = ../config/wlogout/reboot.png;
  xdg.configFile."wlogout/shutdown.png".source = ../config/wlogout/shutdown.png;

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

  home.file.".xinitrc".source = ../config/xorg/xinitrc.sh;
}

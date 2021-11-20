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
    appimage-run
    bitwarden
    electron-mail
    element-desktop
    fractal
    gcc
    guvcview
    kate
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
    bitwarden-cli
    fd
    figlet
    fortune
    glow
    gotop
    libnotify
    lolcat
    neo-cowsay
    nixpkgs-fmt
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

    # Language servers and tools
    gopls
    tree-sitter

    # Fonts
    corefonts
    line-awesome
    powerline-fonts

    # Themes
    nordic

    # Icons
    numix-icon-theme-circle

    # Custom
    convox
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

  xdg.configFile."tridactyl/tridactylrc".source = ../config/firefox/tridactylrc;

  home.file.".mozilla/native-messaging-hosts/tridactyl.json".source = "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";

  # Neovim

  xdg.configFile."nvim/lua/init.lua".source = ../config/nvim/lua/init.lua;
  xdg.configFile."nvim/lua/plugins.lua".source = ../config/nvim/lua/plugins.lua;
  xdg.configFile."nvim/ftplugin".source = ../config/nvim/ftplugin;

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

  # Create configuration file by downloading the contents of the Nord theme and appending our
  # own options to it
  xdg.configFile."alacritty/alacritty.yml".source = builtins.toFile "alacritty.yml" (
    builtins.readFile ( builtins.fetchurl { url =
      "https://raw.githubusercontent.com/arcticicestudio/nord-alacritty/d4b6d2049157a23958dd0e7ecc4d18f64eaa36f3/src/nord.yml";
      sha256 = "0adp4v2d5w6j4j2lavgwbq2x8gnvmxk4lnmlrvl9hy62rxrqp561"; }) + ''

      font:
        normal:
          family: 'Input Mono Condensed'
        bold:
          family: 'Input Mono Condensed'
        italic:
          family: 'Input Mono Condensed'
        bold_italic:
          family: 'Input Mono Condensed'
        size: 9
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

    shellAliases = {
      ll = "ls -lah"; # Same as built-in `l` (muscle memory reasons)
      cat = "bat"; # For syntax highlighting

      # Open Nix configuration in various editors with `/etc/nixos` working dir
      cdnix = "cd /etc/nixos"; cdn = "cdnix";
      nixkate = "nixwith kate";
      nixcode = "nixwith codium";
      nixvim = "nixwith vim";

      # Nix
      nb = "$HOME/.nix-prebuild; sudo nixos-rebuild switch --flake /etc/nixos --upgrade";
    };

    initExtra = ''
      # Zsh configuration
      #
      # * Manual available at https://zsh.sourceforge.io/Doc

      #
      # Variables
      #

      # ANSI color code helpers
  
      export ANSI_STYLE_MD=$(tput bold; tput setaf 6)
      export ANSI_STYLE_ME=$(tput sgr0)
      export ANSI_STYLE_SO=$(tput bold; tput setaf 3; tput setab 4)
      export ANSI_STYLE_SE=$(tput rmso; tput sgr0)
      export ANSI_STYLE_US=$(tput smul; tput bold; tput setaf 7)
      export ANSI_STYLE_UE=$(tput rmul; tput sgr0)
      export ANSI_STYLE_MR=$(tput rev)
      export ANSI_STYLE_MH=$(tput dim)
      export ANSI_STYLE_STATUS=$(tput bold; tput setaf 0; tput setab 3)
      export ANSI_STYLE_STATUS_END=$(tput sgr0)

      # less

      local statusline=$ANSI_STYLE_STATUS"\ ?f\ %f:藍\ STDIN"$ANSI_STYLE_STATUS_END

      export LESS="-iR -Pm$statusline\$ -Ps$statusline\$"
      export LESSEDIT="%E ?lm+%lm. %g"
      export PAGER="less"

      # Notes

      export NOTES_FILE="$HOME/.notes.md"
      export NOTES_EDITOR="$EDITOR"
      export NOTES_VIEWER="glow -p"

      # bat

      export BAT_STYLE="changes"
      export BAT_THEME="Nord"

      # fzf

      export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!node_modules/*"'
      export FZF_DEFAULT_OPTS="--ansi --color='bg+:-1' --no-info --prompt '› ' --pointer '» ' --marker '✓ ' --bind 'ctrl-b:toggle-preview,tab:down,btab:up,ctrl-y:execute-silent(echo {} | wl-copy),ctrl-o:execute-silent(xdg-open {})' --preview-window ':hidden' --preview '([[ -f {} ]] && (bat --style=changes --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'"
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"
      export FZF_ALT_C_OPTS="$FZF_DEFAULT_OPTS"
      export FZF_CTRL_R_OPTS="$FZF_DEFAULT_OPTS"

      #
      # Functions
      #

      set-keyboard-layout() {
        local default="'us,se'"
        swaymsg input type:keyboard xkb_layout "''${@:-$default}"
      }

      set-keyboard-variant() {
        local default="','"
        swaymsg input type:keyboard xkb_variant "''${@:-$default}"
      }

      #
      # Notes
      #

      # Open the notes file for viewing.
      #
      # Globals:
      #   NOTES_FILE
      #   NOTES_VIEWER
      view-notes() {
        eval "''${NOTES_VIEWER:-cat} $NOTES_FILE"
      }

      # Open the notes file for editing.
      #
      # Globals:
      #   EDITOR
      #   NOTES_FILE
      #   NOTES_EDITOR
      edit-notes() {
        eval "''${NOTES_EDITOR:-$EDITOR} $NOTES_FILE"
      }

      # Prepend a list item to the notes file.
      #
      # Globals:
      #   NOTES_FILE
      prepend-note() {
        local note="''${@:-$BUFFER}"

        if ! [ -z "$note" ]; then
          backup-notes
          printf "- $note\n$(cat "$NOTES_FILE")" > "$NOTES_FILE"
          [ $# -eq 0 ] && zle kill-whole-line > /dev/null 2>&1
        fi
      }

      # Create a new backup of the notes file.
      #
      # Globals:
      #   NOTES_FILE
      backup-notes() {
        cp --backup=numbered "$NOTES_FILE" "$NOTES_FILE.$(date +%Y%m%d)"
      }

      # Removes all note backup files except the most recent.
      #
      # Globals:
      #   NOTES_FILE
      clear-backup-notes() {
        rm $NOTES_FILE.*.*
      }

      # Checks if the given argument is a valid command or shell builtin.
      #
      # Arguments:
      #   Command to check for
      is-command() {
        if [ -n "$ZSH_VERSION" ]; then
          builtin whence -p "$1" &> /dev/null
        else
          builtin type -P "$1" &> /dev/null
        fi

        [ $? -ne 0 ] && return 1

        if [ $# -gt 1 ]; then
          shift
          is-command "$@"
        fi
      }

      # Inserts a string to command history without executing it.
      append-to-history() {
        fc -R =(printf "%s\n" "$@")
      }

      # Print a message and wait single key input, for use in command substitution.
      #
      # Arguments:
      #   Prompt message
      await-any-key() {
        printf "%s" "''${*:-Press any key to continue...}"
        read -ks
      }

      # Print a message and wait for y or n response, for use in command substitution. Outputs
      # true or false depending on response.
      #
      # Arguments:
      #   Prompt message
      await-confirm() {
        local prompt="''${*:-Would you like to continue?} [Y/n] "
        local output="false"
        local code=1

        read -qs "key?$prompt"
        code=$?
        [ $code -eq 0 ] && output="true"

        printf "%s" "$output"
        return $code
      }

      # Print a message and wait for enter key, for use in command substitution.
      #
      # Arguments:
      #   Prompt message
      await-enter-key() {
        printf "%s" "''${*:-Press ENTER to continue...}"

        # Simply `read -s` works as well, if delimiter is newline
        while read -ks key; do
          [ "$key" = $'\x0a' ] && break
        done
      }

      # Print a message and wait for user input then output it, for use in command substitution.
      #
      # Arguments:
      #   Prompt message
      await-string-input() {
        printf "%s " "''${*:->}"
        read input
        printf "%s" "$input"
      }

      # Convert text to lowercase.
      #
      # Arguments:
      #   Text to convert
      to-lowercase() {
        printf "%s" "$(printf "%s" "$*" | tr '[:upper:]' '[:lower:]')"
      }

      # Convert text to uppercase.
      #
      # Arguments:
      #   Text to convert
      to-uppercase() {
        printf "%s" "$(printf "%s" "$*" | tr '[:lower:]' '[:upper:]')"
      }

      # Run command in specified directory then return (use with care).
      #
      # Arguments:
      #   Directory to run command in
      #   Command to run
      # Returns:
      #   0 on success, 1 on invalid argument count
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

      # Open /etc/nixos directory with specified program
      #
      # Arguments:
      #   Command or program to open directory with
      # Returns:
      #   0 on success, 1 on invalid argument count
      # Dependencies:
      #   runindir()
      nixwith() {
        if ! [ $# -eq 1 ]; then
          echo "Expected a single argument."
          return 1
        fi

        runindir "/etc/nixos" "$1"
      }

      # Run fg command if buffer line is empty, otherwise save input to stack
      fancy-ctrl-z () {
        if [ $#BUFFER -eq 0 ]; then
          BUFFER="fg"
          zle accept-line
        else
          zle push-input
          zle clear-screen
        fi
      }

      #
      # Widgets
      #

      zle -N fancy-ctrl-z
      zle -N view-notes
      zle -N prepend-note
      zle -N edit-notes
      zle -N backup-notes
      zle -N clear-backup-notes

      #
      # Key Binds
      #

      bindkey '^Z' fancy-ctrl-z
      bindkey "^[s" sudo-command-line
      bindkey "^[e" edit-notes
      bindkey "^[E" prepend-note
      bindkey "^[^E" view-notes
    '';
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

{ pkgs, nixpkgs, ... }:

{
  #
  # Modules
  #

  imports = [
    ../modules/vscodium.nix
  ];

  #
  # Sway
  #

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  #
  # Packages
  #

  home.packages =
  let
    convox = pkgs.callPackage ../packages/convox.nix {};
  in
  with pkgs; [
    bitwarden
    bitwarden-cli
    fd
    guvcview
    kate
    qbittorrent
    qutebrowser
    ripgrep
    slack
    swayidle
    swaylock
    tor-browser-bundle-bin
    wl-clipboard
    wofi
    yubikey-manager

    tridactyl-native
    plasma-browser-integration
    chrome-gnome-shell

    nodePackages.bash-language-server
    nodePackages.eslint
    nodePackages.typescript
    nodePackages.typescript-language-server

    corefonts
    input-fonts
    powerline-fonts

    arc-icon-theme
    faba-icon-theme
    faba-mono-icons
    flat-remix-icon-theme
    kora-icon-theme
    luna-icons
    maia-icon-theme
    moka-icon-theme
    numix-icon-theme
    numix-icon-theme-circle
    numix-icon-theme-square
    paper-icon-theme
    papirus-icon-theme
    pop-icon-theme
    qogir-icon-theme
    zafiro-icons

    numix-cursor-theme

    arc-kde-theme
    arc-theme
    nordic

    convox
  ];

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
        https-everywhere
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
          family: 'CaskaydiaCove Nerd Font'
        bold:
          family: 'CaskaydiaCove Nerd Font'
        italic:
          family: 'CaskaydiaCove Nerd Font'
        bold_italic:
          family: 'CaskaydiaCove Nerd Font'
        size: 9
        offset:
          x: 0
          y: 4
        glyph_offset:
          x: 0
          y: 2
      window:
        padding:
          x: 12
          y: 8
        dynamic_padding: false
      background_opacity: 0.92
    ''
  );

  programs.alacritty = {
    enable = true;
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
      lualine-nvim
      nerdcommenter
      nerdtree
      nord-nvim
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
    ];
  };

  #
  # ZSH and Plugins
  #

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
    };

    shellAliases = {
      ll = "ls -Al";
      nixkate = "kate /etc/nixos";
      nixcode = "codium /etc/nixos";
      nixvim = "nvim /etc/nixos";
      nixrb = "sudo nixos-rebuild switch --flake /etc/nixos";
    };
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

  # Direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    nix-direnv.enableFlakes = true;
  };

  # Mako notification daemon
  programs.mako = {
    backgroundColor = "#F3F3F3FF";
    borderColor = "#000000BB";
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
    textColor = "#222222";
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

  #
  # Environment
  #

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}

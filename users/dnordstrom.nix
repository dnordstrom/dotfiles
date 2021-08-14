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
    alacritty
    bitwarden
    bitwarden-cli
    guvcview
    kate
    qbittorrent
    qutebrowser
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
    nodePackages.typescript-language-server

    convox
  ];

  #
  # Miscellaneous
  #

  programs.bat.enable = true;

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

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
  # Git
  #

  programs.git = {
    userName  = "dnordstrom";
    userEmail = "d@mrnordstrom.com";
    aliases = {
      co = "checkout";
      br = "branch";
    };
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
      nvim-compe
      vim-javascript
      vim-markdown
      vim-nix
      vim-surround
      nvim-lspconfig
      nerdtree
    ];
  };

  #
  # Direnv (Per Directory Environments)
  #

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.nix-direnv.enableFlakes = true;

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
      nixswitch = "sudo nixos-rebuild switch --flake /etc/nixos";
    };

    initExtra = ''
      ga () {
        git add .
      }

      gc () {
        git commit -am "$1"
      }

      gf () {
        git fetch && git pull
      }

      gp () {
        git push
      }
    '';
  };

  #
  # Environment
  #

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}

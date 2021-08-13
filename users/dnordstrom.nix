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
  # Applications
  #

  home.packages = 
  let
    convox = pkgs.callPackage ../packages/convox.nix {};
  in
  with pkgs; [
    swaylock
    swayidle
    wl-clipboard
    mako
    alacritty
    wofi
    kate
    firefox-devedition-bin
    tridactyl-native
    slack
    tor-browser-bundle-bin
    qbittorrent
    qutebrowser

    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    nodePackages.eslint
    
    convox
  ];

  #
  # Git
  #

  programs.git = {
    userName  = "dnordstrom";
    userEmail = "d@mrnordstrom.com";
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

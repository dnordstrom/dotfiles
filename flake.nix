{
  description = "nordix system configuration";

  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    nixpkgs-master = { url = "github:NixOS/nixpkgs/master"; };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.master.follows = "master";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.master.follows = "master";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
    rust-overlay = { url = "github:oxalica/rust-overlay"; };
    # Disabled pending https://github.com/mozilla/nixpkgs-mozilla/pull/290
    # firefox-nightly = {
    #   url = "github:colemickens/flake-firefox-nightly";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixpkgs-mozilla = {
      url = "github:marcenuc/nixpkgs-mozilla";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils = { url = "github:gytis-ivaskevicius/flake-utils-plus"; };
  };

  outputs = inputs@{ self, agenix, nixpkgs, nixpkgs-master, nixpkgs-wayland
    , nixpkgs-mozilla, home-manager, neovim-nightly-overlay, rust-overlay, utils
    , ... }:
    let
      inherit (utils.lib) mkFlake;
      system = "x86_64-linux";
      nixpkgs-master-overlay = final: prev: {
        masterPackages = nixpkgs-master.legacyPackages.${prev.system};
      };
      # Disabled pending https://github.com/mozilla/nixpkgs-mozilla/pull/290
      # firefox-nightly-overlay = final: prev: {
      #   firefox-nightly-bin =
      #     firefox-nightly.packages.${prev.system}.firefox-nightly-bin;
      # };
      # moz-url = builtins.fetchTarball {
      #   url =
      #     "https://github.com/marcenuc/nixpkgs-mozilla/archive/master.tar.gz";
      # };
      # firefox-nightly = { overlay = import "${moz-url}/firefox-overlay.nix"; };
      input-overlays = [
        agenix.overlay
        nixpkgs-master-overlay
        nixpkgs-wayland.overlay
        nixpkgs-mozilla.overlay
        neovim-nightly-overlay.overlay
        rust-overlay.overlay
      ];
      import-overlays = import ./overlays;
    in mkFlake {
      inherit self inputs;

      supportedSystems = [ system ];

      channelsConfig = {
        allowBroken = false;
        allowUnfree = true;
        allowUnsupportedSystem = false;
      };

      specialArgs = { inherit inputs; };

      sharedOverlays = input-overlays ++ import-overlays;

      hostDefaults.modules = [
        ./modules/common.nix
        agenix.nixosModule

        home-manager.nixosModules.home-manager
        {
          home-manager.backupFileExtension = "bak";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dnordstrom = import ./users/dnordstrom.nix;
        }
      ];

      hosts.nordix.modules = [ ./hosts/ryzen.nix ];
      hosts.nordixlap.modules = [ ./hosts/dell-xps.nix ];
    };
}

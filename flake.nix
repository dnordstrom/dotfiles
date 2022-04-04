{
  description = "nordix system configuration";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    nixpkgs-master = { url = "github:NixOS/nixpkgs/master"; };
    nixpkgs-staging = { url = "github:NixOS/nixpkgs/staging"; };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.master.follows = "master";
    };
    nixpkgs-pulseaudio-fix = {
      url = "github:jonringer/nixpkgs/5c14743a3cbeb6dffb37333b71fafc6b0a6b35da";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.master.follows = "master";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
    firefox-nightly = {
      url = "github:colemickens/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = { url = "github:oxalica/rust-overlay"; };
    utils = { url = "github:gytis-ivaskevicius/flake-utils-plus"; };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-master, nixpkgs-staging
    , nixpkgs-wayland, nixpkgs-pulseaudio-fix, home-manager, neovim-nightly-overlay, firefox-nightly
    , rust-overlay, utils, ... }:
    let
      inherit (utils.lib) mkFlake;
      system = "x86_64-linux";
      nixpkgs-master-overlay = final: prev: {
        masterPackages = nixpkgs-master.legacyPackages.${prev.system};
      };
      nixpkgs-staging-overlay = final: prev: {
        stagingPackages = nixpkgs-staging.legacyPackages.${prev.system};
      };
      nixpkgs-pulesaudio-fix-overlay = final: prev: {
        pulseaudioFixPackages = nixpkgs-pulseaudio-fix.legacyPackages.${prev.system};
      };
      firefox-nightly-overlay = final: prev: {
        firefox-nightly-bin =
          firefox-nightly.packages.${prev.system}.firefox-nightly-bin;
      };
      moz-url = builtins.fetchTarball {
        url =
          "https://github.com/marcenuc/nixpkgs-mozilla/archive/master.tar.gz";
      };
      temporaryNightlyOverlay = (import "${moz-url}/firefox-overlay.nix");

      input-overlays = [
        nixpkgs-master-overlay
        nixpkgs-wayland.overlay
        nixpkgs-staging-overlay
        # firefox-nightly-overlay
        rust-overlay.overlay
        temporaryNightlyOverlay
        neovim-nightly-overlay.overlay
        nixpkgs-pulesaudio-fix-overlay
      ];
      import-overlays = import ./overlays;
    in mkFlake {
      inherit self inputs;

      supportedSystems = [ system ];

      channelsConfig = {
        allowBroken = true;
        allowUnfree = false;
        allowUnsupportedSystem = true;
      };

      # Top-level arguments (e.g. `{ pkgs, lib, inputs, ... }:`)
      specialArgs = { inherit inputs; };

      sharedOverlays = input-overlays ++ import-overlays;

      hostDefaults.modules = [
        ./modules/common.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.backupFileExtension = "bak";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dnordstrom = import ./users/dnordstrom.nix;
        }
      ];

      hosts.nordix.modules = [ ./hosts/ryzen.nix ];
      hosts.nordixlap.modules = [ ./hosts/xps.nix ];
    };
}

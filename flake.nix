{
  description = "nordix system configuration";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs-wayland";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-mozilla = {
      url = "github:mozilla/nixpkgs-mozilla";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, agenix, nixpkgs-mozilla, nixpkgs, nixpkgs-wayland
    , home-manager, neovim-nightly-overlay, rust-overlay, utils, ... }:
    let
      inherit (utils.lib) mkFlake;

      input-overlays = [
        agenix.overlay
        nixpkgs-mozilla.overlay
        neovim-nightly-overlay.overlay
        rust-overlay.overlay
      ];

      import-overlays = import ./overlays;

      system = "x86_64-linux";
    in mkFlake {
      inherit self inputs;

      supportedSystems = [ system ];

      channelsConfig = {
        allowBroken = true;
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };

      specialArgs = { inherit inputs; };

      sharedOverlays = input-overlays ++ import-overlays;

      hostDefaults.modules = [
        ./modules/common.nix
        agenix.nixosModule
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            backupFileExtension = "bak";
            useGlobalPkgs = true;
            useUserPackages = true;
            users = { dnordstrom = import ./users/dnordstrom.nix; };
          };
        }
      ];

      hosts = {
        nordix = { modules = [ ./hosts/ryzen.nix ]; };
        nordixlap = { modules = [ ./hosts/dell-xps.nix ]; };
      };
    };
}

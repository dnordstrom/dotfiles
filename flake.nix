{
  description = "nordix system configuration";

  inputs = {
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs-wayland";
    nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, agenix, nixpkgs-mozilla, nixpkgs, nixpkgs-wayland
    , home-manager, neovim-nightly-overlay, rust-overlay, utils, ... }:
    let
      inherit (utils.lib) mkFlake;

      input-overlays = [
        agenix.overlay
        neovim-nightly-overlay.overlay
        nixpkgs-mozilla.overlay
        rust-overlay.overlays.default
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
            users.dnordstrom = import ./users/dnordstrom.nix;
          };
        }
      ];

      hosts = {
        nordix = { modules = [ ./hosts/ryzen.nix ]; };
        nordixlap = { modules = [ ./hosts/dell-xps.nix ]; };
      };
    };
}

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

    firefox-nightly = {
      url = "github:colemickens/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    utils = { url = "github:gytis-ivaskevicius/flake-utils-plus"; };
  };

  outputs = inputs@{ self, agenix, firefox-nightly, nixpkgs, nixpkgs-master
    , nixpkgs-wayland, home-manager, neovim-nightly-overlay, rust-overlay, utils
    , ... }:
    let
      inherit (utils.lib) mkFlake;

      system = "x86_64-linux";

      nixpkgs-master-overlay = final: prev: {
        masterPackages = nixpkgs-master.legacyPackages.${prev.system};
      };

      firefox-nightly-overlay = final: prev: {
        firefox-nightly-bin =
          firefox-nightly.packages.${prev.system}.firefox-nightly-bin;
      };

      input-overlays = [
        agenix.overlay
        firefox-nightly-overlay
        nixpkgs-master-overlay
        nixpkgs-wayland.overlay
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

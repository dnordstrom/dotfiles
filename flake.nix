{
  description = "nordix system configuration";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    nixpkgs-master = { url = "github:NixOS/nixpkgs/master"; };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-contrib = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
    firefox-nightly = {
      url = "github:colemickens/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils = { url = "github:gytis-ivaskevicius/flake-utils-plus"; };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-master, nixpkgs-wayland
    , home-manager, nur, neovim-contrib, neovim-nightly-overlay, firefox-nightly
    , utils, ... }:
    let
      inherit (utils.lib) mkFlake;
      system = "x86_64-linux";
      nixpkgs-master-overlay = final: prev: {
        masterPackages = nixpkgs-master.legacyPackages.${prev.system};
      };
      nixpkgs-wayland-overlay = final: prev: {
        waylandPackages = nixpkgs-wayland.legacyPackages.${prev.system};
      };
      firefox-nightly-overlay = final: prev: {
        firefox-nightly-bin =
          firefox-nightly.packages.${prev.system}.firefox-nightly-bin;
      };
      input-overlays = [
        nur.overlay
        nixpkgs-master-overlay
        nixpkgs-wayland-overlay
        firefox-nightly-overlay
        neovim-nightly-overlay.overlay
      ];
      import-overlays = import ./overlays;
    in mkFlake {
      inherit self inputs;

      supportedSystems = [ system ];

      channelsConfig = {
        allowBroken = true;
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };

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

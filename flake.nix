{
  description = "nordix system configuration";

  inputs = {
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";

    firefox.inputs.nixpkgs.follows = "nixpkgs";
    firefox.url = "github:colemickens/flake-firefox-nightly";

    homemanager.inputs.nixpkgs.follows = "nixpkgs";
    homemanager.url = "github:nix-community/home-manager";

    mozpkgs.url = "github:mozilla/nixpkgs-mozilla";

    neovim.inputs.nixpkgs.follows = "nixpkgs";
    neovim.url = "github:nix-community/neovim-nightly-overlay";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    rust.inputs.nixpkgs.follows = "nixpkgs";
    rust.url = "github:oxalica/rust-overlay";

    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    waypkgs.inputs.nixpkgs.follows = "nixpkgs";
    waypkgs.url = "github:nix-community/nixpkgs-wayland";
  };

  outputs = inputs@{ self, agenix, firefox, mozpkgs, nixpkgs, waypkgs
    , homemanager, neovim, rust, utils, ... }:
    let
      inherit (utils.lib) mkFlake;

      specialArgs = { inherit inputs; };

      input-overlays =
        [ agenix.overlay neovim.overlay mozpkgs.overlay rust.overlays.default ];

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

      specialArgs = specialArgs;

      sharedOverlays = input-overlays ++ import-overlays;

      hostDefaults.modules = [
        ./modules/common.nix
        agenix.nixosModule
        homemanager.nixosModules.home-manager
        (let args = { inherit inputs; };
        in {
          home-manager = {
            backupFileExtension = "bak";
            extraSpecialArgs = args;
            useGlobalPkgs = true;
            useUserPackages = true;
            users.dnordstrom = import ./users/dnordstrom.nix;
          };
        })
      ];

      hosts = {
        nordix = { modules = [ ./hosts/ryzen.nix ]; };
        nordixlap = { modules = [ ./hosts/dell-xps.nix ]; };
      };
    };
}

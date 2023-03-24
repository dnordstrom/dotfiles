{
  description = "NX :: nordix configuration";

  inputs = {
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";

    firefox.inputs.nixpkgs.follows = "nixpkgs";
    firefox.url = "github:colemickens/flake-firefox-nightly";

    homemanager.inputs.nixpkgs.follows = "nixpkgs";
    homemanager.url = "github:nix-community/home-manager";

    # Flake at
    # [github:nix-community/neovim-nightly-overlay](https://github.com/nix-community/neovim-nightly-overlay)
    # broke due to improvements upstream. Fix is in the works, and could even be released by the
    # time you hear or see this, but let's pin its `nixpkgs` to a point before it happens as the
    # simplest solution until `nixpkgs` is confirmed to play well with upstream, and nice versa.
    #
    # TODO: Switch back to the official Neovim contributor's flake (github:neovim/neovim?dir=contrib)
    # once it's confirmed working, issues closed, PRs merged, incident post-mortem scheduled, risk
    # assessment scenarios re-worked, crisis management, refined, policies updated. 
    #
    # NOTE: The daily releases built from trunk are available as AppImages if needed. Very nice.
    #
    # * Nixpkgs bug report:  
    #   https://github.com/NixOS/nixpkgs#208103  
    #     
    # * Nixpkgs PR:  
    #   https://github.com/NixOS/nixpkgs/pull/208103
    #
    # * Neovim PR:  
    #   https://github.com/neovim/neovim/pull/21586
    neovim.url = "github:nix-community/neovim-nightly-overlay";
    neovim.inputs.nixpkgs.url = "github:nixos/nixpkgs?rev=fad51abd42ca17a60fc1d4cb9382e2d79ae31836";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    rust.inputs.nixpkgs.follows = "nixpkgs";
    rust.url = "github:oxalica/rust-overlay";

    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    waypkgs.inputs.nixpkgs.follows = "nixpkgs";
    waypkgs.url = "github:nix-community/nixpkgs-wayland";
  };

  outputs = inputs@{ self, agenix, firefox, nixpkgs, waypkgs, homemanager
    , neovim, rust, utils, ... }:
    let
      inherit (utils.lib) mkFlake;

      specialArgs = { inherit inputs; };
      system = "x86_64-linux";

      # 1. Overlays from the `./overlays/default.nix` module.
      # 2. Overlays from the flake inputs, like nightly Neovim and Firefox.
      #
      # Many Neovim plugins require the nightly version these days due to great features being 
      # added and used by cool plugins, and the API expanding at a rapid pace. With the API becoming
      # more stable, hopefully we can make plugins without assuming latest nightly alpha version.
      # Use overlays from the `./overlays/default.nix` module.
      overlay-import = import ./overlays;
      overlay-inputs = [ agenix.overlays.default neovim.overlay rust.overlays.default ];
    in mkFlake {
      inherit self inputs;

      supportedSystems = [ system ];

      channelsConfig = {
        allowBroken = true;
        allowUnfree = true;
        allowUnsupportedSystem = true;
        joypixels.acceptLicense = true; # TODO: Check if I actually use this or other unfree shit.
      };

      # Args passed to every Nix file loaded, from `./hosts/`, to `./users/`, and gone.
      specialArgs = specialArgs; 

      sharedOverlays = overlay-import ++ overlay-inputs;

      hostDefaults.modules = [
        # Equivalent of the good old `configuration.nix` (which it started as, before flakes).
        ./modules/common.nix

        # Encrypts and decrypts what shouldn't be viewable in a public Git repository. Could be SSH
        # and GPG keys, shell variables to export, and so on.
        agenix.nixosModules.default
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

      hosts.nordix.modules = [ ./hosts/ryzen.nix ];
      hosts.nordixlap.modules = [ ./hosts/dell-xps.nix ];
    };
}

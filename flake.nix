{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nur.url = "github:nix-community/NUR";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

  outputs = inputs@{ self, nixpkgs, nur, home-manager, neovim-nightly-overlay }: rec {
    nixosConfigurations.nordix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        {
          nixpkgs.overlays = [
            neovim-nightly-overlay.overlay
            nur.overlay
          ];
        }
        ({ pkgs, ... }:
          let
            nur-no-pkgs = import nur {
              nurpkgs = import nixpkgs { system = "x86_64-linux"; };
            };
          in {
            imports = [ ];
         })

        ./hosts/ryzen.nix
        ./common.nix

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dnordstrom = import ./users/dnordstrom.nix;
        }

        ({ pkgs, ... }: {
          programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";

          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
        })
      ];
    };
    defaultPackage.x86_64-linux = nixosConfigurations.nordix.config.system.build.vm;
  };
}

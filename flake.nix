{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.firefoxNightly.url = "github:colemickens/flake-firefox-nightly";

  outputs = { self, nixpkgs, firefoxNightly, home-manager }: {

    nixosConfigurations.nordixlap = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
	  ./common.nix

	  home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.dnordstrom = import ./dnordstrom.nix;
          }

	  ({ pkgs, ... }: {
	    programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";

	    system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          })
        ];
    };

  };
}

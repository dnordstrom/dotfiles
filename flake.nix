{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {

    nixosConfigurations.nordixlap = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
	  ./common.nix

	  ({ pkgs, ... }: {
	    programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
	    
	    system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          })
        ];
    };

  };
}

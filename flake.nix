{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.03";

  outputs = { self, nixpkgs }: {

    nixosConfigurations.nordix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
	  "/etc/nixos/common.nix"
	  ({ pkgs, ... }: {
	    packages = with pkgs; [
	       chromium
	    ];
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          })
        ];
    };

  };
}

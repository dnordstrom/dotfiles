{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {

    nixosConfigurations.nordix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
	  ./common.nix

	  ({ pkgs, ... }: {
	    #packages = with pkgs; [
	    #   chromium
	    #   alacritty
	    #];
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          })
        ];
    };

  };
}

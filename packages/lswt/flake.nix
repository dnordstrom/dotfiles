{
  description = "List Wayland toplevels.";

  inputs = { nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; }; };

  outputs = { self, nixpkgs }:
    let pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      packages.x86_64-linux = let
        pkgs = import nixpkgs rec {
          system = "x86_64-linux";

          overlays =
            [ (final: prev: { lswt = pkgs.callPackage ./default.nix { }; }) ];
        };
      in { lswt = pkgs.lswt; };

      defaultPackage.x86_64-linux = self.packages.x86_64-linux.lswt;

      overlay = final: prev: { lswt = pkgs.callPackage ./default.nix { }; };

      overlays = [ self.overlay ];

      devShells.x86_64-linux.lswt =
        pkgs.mkShell { buildInputs = [ pkgs.lswt ]; };
      devShell.x86_64-linux = self.devShells.x86_64-linux.lswt;
    };
}

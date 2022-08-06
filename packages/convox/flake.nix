{
  description = "Multicloud Platform as a Service";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.convox =
      nixpkgs.legacyPackages.x86_64-linux.callPackage ./default.nix { };

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.convox;
  };
}

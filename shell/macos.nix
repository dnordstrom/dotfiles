with import <nixpkgs> { };

mkShell { buildInputs = [ qemu python3 iproute2 ]; }

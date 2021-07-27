with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "node-12";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [
    nodejs-12_x
    (yarn.override { nodejs = nodejs-12_x; })
  ];
  shellHook = ''
    export PATH="$PWD/node_modules/.bin/:$PATH"
  '';
}

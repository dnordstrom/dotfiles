with import <nixpkgs> { };

stdenv.mkDerivation rec {
  name = "node-16";
  env = buildEnv {
    name = name;
    paths = buildInputs;
  };
  buildInputs = [ nodejs-16_x (yarn.override { nodejs = nodejs-16_x; }) ];
  shellHook = "export PATH=$PWD/node_modules/.bin/:$PATH";
}

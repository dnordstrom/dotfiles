with import <nixpkgs> { };

stdenv.mkDerivation rec {
  name = "node-14";
  env = buildEnv {
    name = name;
    paths = buildInputs;
  };
  buildInputs = [ nodejs-14_x (yarn.override { nodejs = nodejs-14_x; }) ];
  shellHook = "export PATH=$PWD/node_modules/.bin/:$PATH";
}

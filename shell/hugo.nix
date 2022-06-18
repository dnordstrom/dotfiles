with import <nixpkgs> { };

stdenv.mkDerivation rec {
  name = "hugo";
  env = buildEnv {
    name = name;
    paths = buildInputs;
  };
  buildInputs = [ hugo git ];
}

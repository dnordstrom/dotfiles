{ stdenv, glibc, gcc-unwrapped, autoPatchelfHook }:
let
  version = "1.0.0";

  src = ./convox;

in stdenv.mkDerivation {
  name = "convox-${version}"

  system = "x86_64-linux";

  inherit src;

  # Required for compilation
  nativeBuildInputs = [
    autoPatchelfHook
  ];

  # Required at running time
  buildInputs = [
    glibc
    gcc-unwrapped
  ];

  unpackPhase = "false";

  # Extract and copy executable in $out/bin
  installPhase = ''
    echo Source ${src}
    echo Source ${out}
    mkdir -p $out
    cp $src $out/bin/
    chmod 755 $out/bin/convox
  '';

  meta = with stdenv.lib; {
    description = "Convox CLI.";
    homepage = https://www.mrnordstrom.com;
    license = licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ "dnordstrom" ];
    platforms = [ "x86_64-linux" ];
  };
}

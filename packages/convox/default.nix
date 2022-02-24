{ stdenv, pkgs }:

let
  name = "convox";
  version = "3.0.0";
in stdenv.mkDerivation {
  name = "${name}";
  pname = "${name}-${version}";
  system = "x86_64-linux";

  src = pkgs.fetchurl {
    url = "https://convox.com/cli/linux/convox";
    sha256 = "sha256-5KTR2OaynlCrc3SixTnSM01S43kbEuInVgvHn8WPtac=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/convox
    chmod 755 $out/bin/convox
  '';
}

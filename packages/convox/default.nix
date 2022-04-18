{ stdenv, pkgs, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "convox";
  version = "3.4.4";
  system = "x86_64-linux";

  src = fetchurl {
    url = "http://github.com/convox/convox/releases/download/${version}/convox-linux";
    sha256 = "sha256-mQb12zs/yQk8tQwhnicoJeNSOUlueJk277o5ZqwO9ek=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/convox
    chmod 755 $out/bin/convox
  '';

  meta = with lib; {
    description = "Convox PaaS command line interface.";
    homepage = "https://github.com/convox/convox";
    license = licenses.asl20;
    maintainers = with maintainers; [ dnordstrom ];
    platforms = platforms.linux;
  };
}

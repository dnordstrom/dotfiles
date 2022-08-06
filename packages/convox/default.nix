{ stdenv, pkgs, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "convox";
  version = "3.5.7";
  system = "x86_64-linux";

  src = fetchurl {
    url =
      "http://github.com/convox/convox/releases/download/${version}/convox-linux";
    sha256 = "sha256-ySkhgd67yuqoeWZw6Oz2azzjVsHQQN9sdAofqvPkz0g=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/convox
  '';

  meta = with lib; {
    description = "Multicloud Platform as a Service.";
    homepage = "https://github.com/convox/convox";
    license = licenses.asl20;
    maintainers = with maintainers; [ dnordstrom ];
    platforms = platforms.linux;
  };
}

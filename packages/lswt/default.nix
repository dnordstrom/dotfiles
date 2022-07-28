{ stdenv, pkgs, lib, fetchGit }:

stdenv.mkDerivation rec {
  pname = "lswt";
  version = "v1.0.4";
  system = "x86_64-linux";

  src = fetchGit {
    url = "https://git.sr.ht/~leon_plickat/lswt";
    ref = "refs/tags/${version}";
    sha256 = "sha256-mQb12zs/yQk8tQwhnicoJeNSOUlueJk277o5ZqwO9ek=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/lswt
    chmod 755 $out/bin/lswt
  '';

  meta = with lib; {
    description = "List Wayland toplevels.";
    homepage = "https://git.sr.ht/~leon_plickat/lswt";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dnordstrom ];
    platforms = platforms.linux;
  };
}

{ alsa-lib, autoPatchelfHook, fetchurl, flac, gcc11, lib, pkgs
, libmicrohttpd, llvmPackages_10, rpmextract, wavpack, qt5, mpg123 }:

let inherit (lib) getDev; in
qt5.mkDerivation rec {
  pname = "hqplayer-desktop";
  version = "4.17.2-53";

  src = fetchurl {
    url =
      "https://www.signalyst.eu/bins/hqplayer/fc35/hqplayer4desktop-${version}.fc35.x86_64.rpm";
    sha256 = "sha256-Z9wtlc0tjG2UPbB4jRau2tKGIxxPkslecc8PkWvlgos=";
  };

  unpackPhase = ''
    ${rpmextract}/bin/rpmextract $src
  '';

  nativeBuildInputs = [ autoPatchelfHook rpmextract pkgs.stagingPackages.glibc ];

  buildInputs = [
    pkgs.stagingPackages.glibc
    alsa-lib
    flac
    gcc11.cc.lib
    libmicrohttpd
    llvmPackages_10.openmp
    mpg123
    qt5.qtcharts
    qt5.qtdeclarative
    qt5.qtquickcontrols2
    qt5.qtwebengine
    qt5.qtwebview
    wavpack
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # main executable
    mkdir -p $out/bin
    cp ./usr/bin/* $out/bin

    # desktop files
    mkdir -p $out/share/applications
    cp ./usr/share/applications/* $out/share/applications

    # documentation
    mkdir -p $out/share/doc/${pname}
    cp ./usr/share/doc/hqplayer4desktop/* $out/share/doc/${pname}

    # pixmaps
    mkdir -p $out/share/pixmaps
    cp ./usr/share/pixmaps/* $out/share/pixmaps

    runHook postInstall
  '';

  postInstall = ''
    for desktopFile in $out/share/applications/*; do
      substituteInPlace "$desktopFile" \
        --replace /usr/bin/ $out/bin/ \
        --replace /usr/share/doc/ $out/share/doc/
    done
  '';

  postFixup = ''
    patchelf --replace-needed libomp.so.5 libomp.so $out/bin/.hqplayer4desktop-wrapped
  '';

  meta = with lib; {
    homepage = "https://www.signalyst.com/custom.html";
    description = "High-end upsampling multichannel software HD-audio player";
    license = licenses.unfree;
    maintainers = with maintainers; [ lovesegfault ];
  };
}

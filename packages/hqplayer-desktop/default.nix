{ alsa-lib, autoPatchelfHook, fetchurl, flac, gcc11, lib, pkgs, libmicrohttpd
, llvmPackages_10, rpmextract, wavpack, qt5, mpg123, libusb-compat-0_1, opencpn }:

let inherit (lib) getDev;
in qt5.mkDerivation rec {
  pname = "hqplayer-desktop";
  version = "4.18.1-55";

  src = fetchurl {
    url =
      "https://www.signalyst.eu/bins/hqplayer/fc35/hqplayer4desktop-${version}.fc35.x86_64.rpm";
    sha256 = "sha256-5fjzOcRnZNYdxORkLeYb+DmuQzyNqlt0kUy5iBLSMj8=";
  };

  libsglnnx = fetchurl {
    url = "https://github.com/bdbcat/o-charts_pi/raw/master/libs/oeserverd/linux64/libsgllnx64-2.29.02.so";
    sha256 = "sha256-2NNQQOAsVkHaEF9N95EGCcMpWix5wGDjiHM0VOJhK3w=";
  };

  libusb = fetchurl {
    url = "https://github.com/bdbcat/o-charts_pi/raw/master/libs/oeserverd/linux64/libusb-0.1.so.4";
    sha256 = "sha256-XAvwQ4WcrP1WlZiYCtK60XWJ/oDbkro7sCzL2rU5B1I=";
  };

  unpackPhase = ''
    ${rpmextract}/bin/rpmextract $src
  '';

  nativeBuildInputs = [ autoPatchelfHook rpmextract ];

  buildInputs = [
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
    opencpn
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

    mkdir $out/lib
    chmod 777 $out/lib
    cp ${libsglnnx} $out/lib/libsgllnx64-2.29.02.so
    cp ${libusb} $out/lib/libusb-0.1.so.4

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

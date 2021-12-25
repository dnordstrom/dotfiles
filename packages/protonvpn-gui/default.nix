{ lib, fetchFromGitHub, gobject-introspection, imagemagick, wrapGAppsHook
, python39Packages, gtk3, networkmanager, webkitgtk }:

let
  # Fetching local `protonvpn-nm-lib` to be used as propagated build input
  protonvpn-nm-lib = python39Packages.callPackage ../protonvpn-nm-lib { };
in python39Packages.buildPythonApplication rec {
  pname = "protonvpn-gui";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "linux-app";
    rev = "refs/tags/${version}";
    sha256 = "sha256-uzooFQBq2mhqTBr/cgea5cVQ889P70sgSk2vjXBQEfw=";
  };

  strictDeps = false;

  nativeBuildInputs = [ gobject-introspection imagemagick wrapGAppsHook ];

  propagatedBuildInputs = [ protonvpn-nm-lib python39Packages.psutil ];

  buildInputs = [ gtk3 networkmanager webkitgtk ];

  postFixup = ''
    # Setting icons
    for size in 16 32 48 64 72 96 128 192 512 1024; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -resize $size'x'$size \
        protonvpn_gui/assets/icons/protonvpn-logo.png \
        $out/share/icons/hicolor/$size'x'$size/apps/protonvpn.png
    done

    install -Dm644 protonvpn.desktop -t $out/share/applications/
    substituteInPlace $out/share/applications/protonvpn.desktop \
      --replace 'protonvpn-logo' protonvpn
  '';

  # Project has a dummy test
  doCheck = false;

  meta = with lib; {
    description = "Linux GUI for ProtonVPN, written in Python";
    homepage = "https://github.com/ProtonVPN/linux-app";
    maintainers = with maintainers; [ offline wolfangaukang ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}

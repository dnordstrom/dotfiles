{ lib, fetchFromGitHub, rustPlatform, pkg-config, extra-cmake-modules, libX11
, libXi, libXtst, libnotify, dbus, openssl, xclip, xdotool, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "espanso";
  version = "2.1.5-beta";

  src = fetchFromGitHub {
    owner = "federico-terzi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/oYRH6bNPKINls2Iq78oF8aLm274iASlZSDvZh1FzZk=";
  };

  cargoSha256 = "sha256-7v6NHEHIRunXAO4nzZiNH2lIs7t0Bf8ylm+OsmNCek8=";

  nativeBuildInputs = [ extra-cmake-modules pkg-config makeWrapper ];

  buildInputs = [ libX11 libXtst libXi libnotify xclip openssl xdotool dbus ];

  # Some tests require networking
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/espanso \
      --prefix PATH : ${lib.makeBinPath [ libnotify xclip ]}
  '';

  meta = with lib; {
    description = "Cross-platform Text Expander written in Rust";
    homepage = "https://espanso.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kimat ];
    platforms = platforms.linux;

    longDescription = ''
      Espanso detects when you type a keyword and replaces it while you're typing.
    '';
  };
}

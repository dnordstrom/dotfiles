# The Mirage version of the Ayu theme packaged by lovesegfault.
##
{ stdenv, autoreconfHook, fetchFromGitHub, gnome, gtk-engine-murrine, gtk3
, inkscape, lib, optipng, pkg-config, sassc }:

stdenv.mkDerivation rec {
  pname = "ayu-mirage-theme-gtk";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "dnordstrom";
    repo = "ayu-theme";
    rev = "10b80185349749eba9ce9fba238ce8215b91d5ac";
    sha256 = "sha256-s7d27BcJGHAf8Og/LZ6c69ewT/Kxm0FYSP5jCpnfIvw=";
  };

  postPatch = ''
    ln -sn 3.20 common/gtk-3.0/3.24
    ln -sn 3.18 common/gnome-shell/3.24
  '';

  nativeBuildInputs = [ autoreconfHook gtk3 inkscape optipng pkg-config sassc ];

  propagatedUserEnvPkgs = [ gnome.gnome-themes-extra gtk-engine-murrine ];

  enableParallelBuilding = true;

  preBuild = ''
    # Shut up inkscape's warnings about creating profile directory
    export HOME="$NIX_BUILD_ROOT"
  '';

  configureFlags =
    [ "--with-gnome-shell=${gnome.gnome-shell.version}" "--disable-unity" ];

  postInstall = ''
    install -Dm644 -t $out/share/doc/${pname} AUTHORS *.md
  '';

  meta = with lib; {
    description = "Ayu colored GTK and Kvantum themes based on Arc";
    homepage = "https://github.com/dnordstrom/ayu-theme/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dnordstrom ];
  };
}

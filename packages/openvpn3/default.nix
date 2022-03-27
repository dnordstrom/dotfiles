{ lib, stdenv, fetchFromGitHub, autoreconfHook, autoconf-archive, git
, pkg-config, glib, jsoncpp, libcap_ng, libnl, libuuid, lz4, openssl, protobuf
, python3, tinyxml-2, docutils, jinja2 }:

stdenv.mkDerivation rec {
  pname = "openvpn3";
  version = "v17_beta";
  
  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "openvpn3-linux";
    rev = "${version}";
    fetchSubmodules = true;
    sha256 = "sha256-vXmNErygbmrZ2zRo0uNNHTo24s93Cfs04cGCFktRyCw=";
  };

  postPatch = ''
    # Hardcode version.m4 according to Git rev
    {
      cat <<EOF
define([PRODUCT_NAME], [OpenVPN 3/Linux])
define([PRODUCT_VERSION], [${version}])
define([PRODUCT_GUIVERSION], [${version}])
define([PRODUCT_TARNAME], [openvpn3-linux])
define([PRODUCT_BUGREPORT], [openvpn-devel@lists.sourceforge.net])
EOF
    } > version.m4

    # Ensure the config-version.h file gets updated
    rm -f config-version.h

    # Hardcode openvpn3-core version obtained from openvpn3-core/scripts/version
    printf "%s" "3.git:HEAD:7765540e" > ./openvpn3-core-version
  '';

  nativeBuildInputs =
    [ autoreconfHook autoconf-archive docutils git jinja2 pkg-config ];
  propagatedBuildInputs = [ python3 ];
  buildInputs =
    [ glib jsoncpp libcap_ng libnl libuuid lz4 openssl protobuf tinyxml-2 ];

  configureFlags = [ "--disable-selinux-build" ];

  NIX_LDFLAGS = "-lpthread";

  meta = with lib; {
    description = "OpenVPN 3 Linux client";
    license = licenses.agpl3Plus;
    homepage = "https://github.com/OpenVPN/openvpn3-linux";
    maintainers = with maintainers; [ dnordstrom ];
    platforms = platforms.linux;
  };
}

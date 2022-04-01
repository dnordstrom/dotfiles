{ lib, stdenv, fetchFromGitHub, autoreconfHook, autoconf-archive, git
, pkg-config, glib, glib-networking, jsoncpp, libcap_ng, libnl, libuuid, lz4
, openssl, protobuf, python3, tinyxml-2, docutils, jinja2 }:

stdenv.mkDerivation rec {
  pname = "openvpn3";
  version = "v17_beta";
  coreVersion = "3.git:master:7765540e";

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "openvpn3-linux";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    sha256 = "sha256-vXmNErygbmrZ2zRo0uNNHTo24s93Cfs04cGCFktRyCw=";
  };

  postPatch = ''
    substituteInPlace ./src/netcfg/netcfg-device.hpp --replace "gio-unix-2.0/gio/gunixconnection.h" "glib-2.0/gio/gunixconnection.h"

    printf "define([PRODUCT_NAME], [OpenVPN 3/Linux])" > version.m4
    printf "define([PRODUCT_VERSION], [%s])" "${version}" >> version.m4
    printf "define([PRODUCT_GUIVERSION], [%s])" "${version}" >> version.m4
    printf "define([PRODUCT_TARNAME], [openvpn3-linux])" >> version.m4
    printf "define([PRODUCT_BUGREPORT], [openvpn-devel@lists.sourceforge.net])" >> version.m4
    printf "%s" "${coreVersion}" > ./openvpn3-core-version
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

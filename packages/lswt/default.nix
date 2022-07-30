{ stdenv, pkgs, lib, wayland, wayland-scanner }:
##
# LSWT
#
# Simple command line utility that lists Wayland window titles and IDs. Written by Leon Plickat for
# River WM but works with any compositor that implements `foreign-toplevel-management-unstable-v1`.
#
# NOTE: His <a href="https://git.sr.ht/~leon_plickat">Sourcehut</a> account is a Wayland gold mine.
##

# We need `rec` to be able to reference the name and version from within the derivation
stdenv.mkDerivation rec {
  #
  # VARIABLES
  #

  name = "lswt"; # This shows up when searching packages
  version = "1.0.4"; # Starting at v1.0.4 to match semantic versioning of `lswt`
  revision = "2453fc1a09ccfd2aa9ca521ae00dbae2c99e575b";

  #
  # SOURCE
  #

  src = builtins.fetchGit {
    url = "https://git.sr.ht/~leon_plickat/lswt";
    ref = "refs/tags/v${version}";
    rev = revision;
  };

  #
  # BUILD
  #

  # We need some Wayland libraries
  buildInputs = [ wayland wayland-scanner ];

  # Can't use `autoreconfHook` since there's no `configure.ac` so we set the prefix ourselves
  installFlags = [ "PREFIX=${placeholder "out"}" ];

  #
  # META
  #

  meta = with lib; {
    description = "List Wayland toplevels.";
    license = licenses.gpl3Only;
    platforms = [ platforms.all ];
    maintainers = [ maintainers.dnordstrom ];
    homepage = "https://git.sr.ht/~leon_plickat/lswt";
    longDescription = ''
      lswt - list Wayland toplevels

      Requires the Wayland server to implement the foreign-toplevel-management-unstable-v1
      protocol extension.

      lswt is licensed under the GPLv3.
    '';
  };
}

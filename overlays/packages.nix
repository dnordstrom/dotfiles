# #
# LOCAL PACKAGES OVERLAY
#
final: prev: {
  nordpkgs = import ../packages { pkgs = final; };
}


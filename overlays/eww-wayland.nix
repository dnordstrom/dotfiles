# #
# EWW WAYLAND WITH SYSTEM TRAY
#
# Overrides source to use PR (fork of 0.2.0) that adds system tray support.
# #

final: prev: {
  eww-wayland = prev.eww-wayland.overrideAttrs (drv: rec {
    # Change version to get correct dependencies below
    pname = "eww";
    version = "0.2.0";

    # No patches necessary for 0.2.0
    cargoPatches = [ ];
    patches = [ ];

    # Use fork/PR source
    src = prev.fetchFromGitHub {
      owner = "oknozor";
      repo = "eww";
      rev = "298a35a382f588a7b04c81b3af385dff7f111066";
      sha256 = "sha256-gag/c3ttRUjyGCUmwgqPQApbTlq4iApyXRA/4sHmXTc=";
    };

    # Use the correct source, fetch the right dependencies, and disable patch
    cargoDeps = drv.cargoDeps.overrideAttrs (prev.lib.const {
      inherit src;

      name = "${pname}-${version}-vendor.tar.gz";
      patches = [ ];
      outputHash = "sha256-THD7JhbjRhGp2x2urO/aYFpm7vx9WAcHw8NFn1r7UFs=";
    });
  });
}

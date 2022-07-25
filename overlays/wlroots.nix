# #
# Temporary workaround to get River WM to build when using nixpkgs-wayland.
#
# See: https://github.com/nix-community/nixpkgs-wayland/issues/313
# #

self: super: {
  nixpkgs = {
    overlays = [
      (self: super: {
        wlroots = super.wlroots.overrideAttrs (_: { version = "0.15"; });
      })
    ];
  };
}

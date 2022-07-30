# #
# VSCODIUM OVERLAY
#
# Modifies desktop files to launch with Chromium Wayland flags
#
final: prev: {
  eww-wayland = prev.eww-wayland.overrideAttrs (oldAttrs: rec {
    src = fetchFromGitHub {
      owner = "elkowar";
      repo = "eww";
      rev = "0b0715fd505200db5954432b8a27ed57e3e6a72a";
      sha256 = "055il2b3k8x6mrrjin6vkajpksc40phcp4j1iq0pi8v3j7zsfk1a";
    };
  });
}

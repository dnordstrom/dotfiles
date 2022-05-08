# #
# Compatibility wrapper to make `nixos-option` work with flake based configurations.
#
# Source: https://github.com/NixOS/nixpkgs/issues/97855#issuecomment-1075818028
#

self: super: {
  nixos-option = let
    flake-compact = super.fetchFromGitHub {
      owner = "edolstra";
      repo = "flake-compat";
      rev = "12c64ca55c1014cdc1b16ed5a804aa8576601ff2";
      sha256 = "sha256-hY8g6H2KFL8ownSiFeMOjwPC8P0ueXpCVEbxgda3pko=";
    };
    prefix =
      "(import ${flake-compact} { src = /etc/nixos; }).defaultNix.nixosConfigurations.\\$(hostname)";
  in super.runCommandNoCC "nixos-option" {
    buildInputs = [ super.makeWrapper ];
  } ''
    makeWrapper ${super.nixos-option}/bin/nixos-option $out/bin/nixos-option \
      --add-flags --config_expr \
      --add-flags "\"${prefix}.config\"" \
      --add-flags --options_expr \
      --add-flags "\"${prefix}.options\""
  '';
}

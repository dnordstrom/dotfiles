# #
# LOCAL PACKAGES
#
# Referenced as `pkgs.nordpkgs`.
#
{ pkgs }: {
  convox = pkgs.callPackage ./convox { };
  hydroxide = pkgs.callPackage ./hydroxide { };
  jira-cli = pkgs.callPackage ./jira-cli { };
  protonvpn-cli = pkgs.callPackage ./protonvpn-cli { };
  protonvpn-gui = pkgs.callPackage ./protonvpn-gui { };
  protonvpn-nm-lib = pkgs.callPackage ./protonvpn-nm-lib { };
  proton-client = pkgs.callPackage ./proton-client { };
  udev-rules = pkgs.callPackage ./udev-rules { };
}

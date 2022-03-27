# #
# LOCAL PACKAGES
#
# Referenced as `pkgs.nordpkgs`.
#
{ pkgs }: {
  ayu-mirage-theme-gtk = pkgs.callPackage ./ayu-mirage-theme-gtk { };
  convox = pkgs.callPackage ./convox { };
  hydroxide = pkgs.callPackage ./hydroxide { };
  jira-cli = pkgs.callPackage ./jira-cli { };
  openvpn3 = pkgs.callPackage ./openvpn3 {
    inherit (pkgs.python3Packages) docutils jinja2;
  };
  proton-client = pkgs.callPackage ./proton-client { };
  protoncheck = pkgs.callPackage ./protoncheck { };
  protonvpn-cli = pkgs.callPackage ./protonvpn-cli { };
  protonvpn-gui = pkgs.callPackage ./protonvpn-gui { };
  protonvpn-nm-lib = pkgs.callPackage ./protonvpn-nm-lib { };
  udev-rules = pkgs.callPackage ./udev-rules { };
}

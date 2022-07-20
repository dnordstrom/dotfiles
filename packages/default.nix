# #
# LOCAL PACKAGES
#
# Referenced as `pkgs.nordpkgs`.
#
{ pkgs }: {
  ayu-mirage-theme-gtk = pkgs.callPackage ./ayu-mirage-theme-gtk { };
  convox = pkgs.callPackage ./convox { };
  jira-cli = pkgs.callPackage ./jira-cli { };
  openvpn3 = pkgs.callPackage ./openvpn3 {
    inherit (pkgs.python3Packages) docutils jinja2;
  };
  protoncheck = pkgs.callPackage ./protoncheck { };
  udev-rules = pkgs.callPackage ./udev-rules { };
}

# #
# LOCAL PACKAGES
#
# Referenced as `pkgs.nordpkgs`.
# #

{ pkgs }: {
  ayu-mirage-theme-gtk = pkgs.callPackage ./ayu-mirage-theme-gtk { };
  convox = pkgs.callPackage ./convox { };
  lswt = pkgs.callPackage ./lswt { };
  jira-cli = pkgs.callPackage ./jira-cli { };
  protoncheck = pkgs.callPackage ./protoncheck { };
  udev-rules = pkgs.callPackage ./udev-rules { };
}

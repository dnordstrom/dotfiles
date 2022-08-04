# #
# LOCAL PACKAGES
#
# Referenced as `pkgs.nordpkgs`.
# #

{ pkgs }: {
  pkgs.ayu-mirage-theme-gtk = pkgs.callPackage ./ayu-mirage-theme-gtk { };
  pkgs.convox = pkgs.callPackage ./convox { };
  pkgs.lswt = pkgs.callPackage ./lswt { };
  pkgs.jira-cli = pkgs.callPackage ./jira-cli { };
  pkgs.protoncheck = pkgs.callPackage ./protoncheck { };
  pkgs.udev-rules = pkgs.callPackage ./udev-rules { };
}

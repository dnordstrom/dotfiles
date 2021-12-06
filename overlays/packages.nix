final: prev: {
  convox = prev.callPackage ../packages/convox.nix {};
  hydroxide = prev.callPackage ../packages/hydroxide.nix {};
  jira-cli = prev.callPackage ../packages/jira-cli.nix {};
  udev-rules = prev.callPackage ../packages/udev-rules.nix {};
}

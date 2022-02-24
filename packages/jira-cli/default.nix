{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jira-cli";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ankitpokhrel";
    repo = "jira-cli";
    rev = "v${version}";
    sha256 = "sha256-2er40ozo4/OETF74tyNfgSsEXAPAZ7UkCVUCnccQSD4=";
  };

  vendorSha256 = "sha256-SzeUSR0ZB47SaE9CAsHAJ/bTa+ZORyGRhW38O9lAvGU=";

  proxyVendor = true;

  doCheck = false; # Due to failing test of $PAGER in pkg/tui/helper_test.go

  meta = with lib; {
    description = "Feature-rich interactive Jira command line.";
    homepage = "https://github.com/ankitpokhrel/jira-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ dnordstrom ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

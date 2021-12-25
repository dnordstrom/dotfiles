{ lib, fetchFromGitHub, python39Packages, openvpn, dialog, iptables }:

python39Packages.buildPythonApplication rec {
  pname = "protonvpn-cli";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "linux-cli";
    rev = "refs/tags/${version}";
    sha256 = "sha256-nFG2ATy4qBfUohSH3ZGoms9jYIa78pnHFUzwv95aUto=";
  };

  propagatedBuildInputs =
    (with python39Packages; [ protonvpn-nm-lib requests docopt setuptools jinja2 pythondialog ])
    ++ [ dialog openvpn iptables ];

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Linux command-line client for ProtonVPN";
    homepage = "https://github.com/ProtonVPN/linux-cli";
    maintainers = with maintainers; [ jtcoolen jefflabonte shamilton ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "protonvpn-cli";
  };
}

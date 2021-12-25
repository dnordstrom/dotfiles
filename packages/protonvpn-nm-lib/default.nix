{ lib
, buildPythonPackage
, python39Packages
, fetchFromGitHub
, pythonOlder
, distro
, jinja2
, keyring
, pygobject3
, pyxdg
, systemd
}:

let
  # Fetching local `proton-client` to be used as propagated build input
  proton-client = python39Packages.callPackage ../proton-client { };
in buildPythonPackage rec {
  pname = "protonvpn-nm-lib";
  version = "3.7.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-RZ10p/Lg9GQj0CohW2v+THch5EaD236rEHETGjNStdY=";
  };

  propagatedBuildInputs = [
    distro
    jinja2
    keyring
    proton-client
    pygobject3
    pyxdg
    systemd
  ];

  # Project has a dummy test.
  doCheck = false;

  pythonImportsCheck = [ "protonvpn_nm_lib" ];

  meta = with lib; {
    description = "ProtonVPN NetworkManager Library intended for every ProtonVPN service user";
    homepage = "https://github.com/ProtonVPN/protonvpn-nm-lib";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}

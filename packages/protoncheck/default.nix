{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

# Updated version of hydroxide since nixpkgs-unstable has 0.2.21
buildGoModule rec {
  pname = "protoncheck";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "servusdei2018";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "";
  };

  vendorSha256 = "";

  doCheck = false;

  meta = with lib; {
    description =
      "Lightweight, fast waybar/polybar/yabar/i3blocks module to check the amount of unread emails in a ProtonMail inbox.";
    homepage = "https://github.com/servusdei2018/protoncheck";
    license = licenses.mit;
    maintainers = with maintainers; [ dnordstrom ];
    platforms = platforms.unix;
  };
}

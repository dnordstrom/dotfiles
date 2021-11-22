buildGoModule rec {
  pname = "jira-cli";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ankitpokhrel";
    repo = "jira-cli";
    rev = "v${version}";
    sha256 = "0m2fzpqxk7hrbxsgqplkg7h2p7gv6s1miymv3gvw0cz039skag0s";
  };

  vendorSha256 = "1879j77k96684wi554rkjxydrj8g3hpp0kvxz03sd8dmwr3lh83j";

  runVend = true;

  meta = with lib; {
    description = "Feature-rich interactive Jira command line.";
    homepage = "https://github.com/ankitpokhrel/jira-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ dnordstrom ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

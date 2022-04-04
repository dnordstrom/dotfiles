# #
# pw-volume
#
# Control PipeWire volume directly via pw-cli without need for PulseAudio or ALSA tools. Small,
# written in Rust, and includes a Waybar module.
#
# Repository: https://github.com/smasher164/pw-volume
# #
{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "pw-volume";
  version = "v0.1.0";

  src = fetchFromGitHub {
    owner = "smasher164";
    repo = pname;
    rev = version;
    sha256 = "sha256-e7TA41aoJJuYsiXOV4mHDeu9UKRwdnpRqW/PZ+rjLbo=";
  };

  cargoSha256 = "sha256-b4XSJwKDdEmpSovys0XY+Gal95vaKGqt7hKkOug0RME=";

  meta = with lib; {
    description = "Basic interface to PipeWire volume controls";
    homepage = "https://github.com/smasher164/pw-volume";
    license = licenses.mit;
    maintainers = [ maintainers.dnordstrom ];
  };
}

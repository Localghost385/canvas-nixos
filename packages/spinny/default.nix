{ lib, rustPlatform, fetchFromGitHub, ... }:

rustPlatform.buildRustPackage rec {
  pname = "spinny";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "localghost385";
    repo = pname;
    rev = "723cb3cbd977311a312c41249b17535bc98960e1";
    sha256 = "sha256-eMppA1CAznhkgMCj07ADrArWmcbMpa2byB69AhV/vlU=";
  };

  cargoHash = "sha256-xcfaLO3tFIbahj4AgHL24GaaUBSJZabAfz8eX+Q1RLk=";

  meta = with lib; {
    description = "A description of my crate";
    homepage = "https://github.com/localghost385/spinny";
    license = licenses.mit;
    maintainers = with maintainers; [ exampleMaintainer ];
  };
}

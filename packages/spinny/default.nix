{ pkgs ? import <nixpkgs> {} }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "spinny";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "localghost385";
    repo = pname;
    rev = "main";
    sha256 = "sha256-IzKVTAfiDBO62gh33a3IGbgqUQqWg3M34NwLJjwpVZk=";
  };

  cargoHash = "sha256-xcfaLO3tFIbahj4AgHL24GaaUBSJZabAfz8eX+Q1RLk=";

  meta = with pkgs.lib; {
    description = "A description of my crate";
    homepage = "https://github.com/localghost385/spinny";
    license = licenses.mit;
    maintainers = with maintainers; [ exampleMaintainer ];
  };
}

{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "canvas-sddm";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "localghost385";
    repo = "canvas-sddm";
    rev = "main";
    hash = "sha256-D4V1k0DA5Y5PXUjJzZ/sxs7ucS0WT0Uo2KYhZR5nAD4=";
  };

  installPhase = ''
    mkdir -p "$out/share/sddm/themes/"
    cp -r . $out/share/sddm/themes/canvas-sddm
  '';

  meta = with pkgs.lib; {
    description = "Canvas sddm theme";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

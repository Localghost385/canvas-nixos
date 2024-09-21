{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "canvas-bibata-cursors";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "localghost385";
    repo = "canvas-bibata";
    rev = "main"; 
    sha256 = "sha256-Ez8jz/C0xPmffsnH8lZKUz8FFJQBBHYGCBt1AAk+Ug4=";
  };

  installPhase = ''
    mkdir -p $out/share/icons/canvas-bibata
    cp -r * $out/share/icons/canvas-bibata
  '';

  meta = with pkgs.lib; {
    description = "Canvas Bibata X cursor theme";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

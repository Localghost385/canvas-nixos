{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "canvas-grub";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "localghost385";
    repo = "canvas-grub";
    rev = "main";
    hash = "sha256-cduIqAUqyDbkgX89LG+GsEo04i8b3FkjEwGpDLRDpI4=";
  };

  installPhase = ''
    mkdir -p $out/share/grub/themes
    cp -r canvas-grub $out/share/grub/themes/
  '';

  meta = with pkgs.lib; {
    description = "Canvas Grub theme";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

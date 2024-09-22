{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "canvas-grub";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "localghost385";
    repo = "canvas-grub";
    rev = "main";
    hash = "sha256-c7FAQQW6G26iNE6Gh9N6XKiszDnxGnnOxkJ533Q37yM=";
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

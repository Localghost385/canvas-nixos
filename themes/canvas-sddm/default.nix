{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "canvas-sddm";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "localghost385";
    repo = "canvas-sddm";
    rev = "main";
    hash = "sha256-/DARkWuBe+WrvemuMU763wFl6bEwcE0Vlqp4VrlmV+s=";
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

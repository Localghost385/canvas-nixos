{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "canvas-gtk";
  version = "0.1.0";

  src = pkgs.fetchgit {
    url = "https://github.com/localghost385/canvas-gtk.git";
    rev = "713e7350c7d3c74f00b356dcb8668cbc0c986e6f";
    fetchSubmodules = true;
    hash = "sha256-IgKYkEPyEklCxXSmCbEFYkCeFPJH8dH46CrsGgym4uA=";
  };


  nativeBuildInputs = [
    pkgs.gtk3
    pkgs.sassc
    pkgs.git
    pkgs.tree
    (pkgs.python3.withPackages (ps: [ ps.catppuccin ]))
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes

    python3 build.py latte --dest $out/share/themes -a lavender

    runHook postInstall
  '';


  meta = {
    description = "Soothing pastel theme for GTK";
    homepage = "https://github.com/localghost385/canvas-gtk";
    license = pkgs.lib.licenses.gpl3Plus;
    platforms = pkgs.lib.platforms.all;
    maintainers = with pkgs.lib.maintainers; [ fufexan dixslyf isabelroses ];
  };
}

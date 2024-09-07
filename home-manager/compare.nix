{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    # Existing imports...
    # ./nvim.nix
  ];

  nixpkgs = {
    overlays = [
      inputs.canvas-nvim.overlays.default
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "grace";
    homeDirectory = "/home/grace";
  };

  # Include the custom spinny package
  home.packages = with pkgs; [
    alsa-utils
    musescore
    obsidian
    mpv
    kitty
    wofi
    brightnessctl
    spotify
    gcc
    gnumake
    cmake
    yarn
    tree
    ags
    upower
    pavucontrol
    swww
    fastfetch
    firefox-wayland
    vscode
    git
    wf-recorder
    nvim-pkg
    # Add spinny here
    (inputs.self.packages.x86_64-linux.spinny or (import ./packages/spinny/default.nix {}).spinny)
  ];

  programs = {
    home-manager = {
      enable = true;
    };
    git = {
      enable = true;
      userEmail = "localghost385@gmail.com";
      userName = "Grace Murphy";
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font Propo";
      size = 10;
    };
    iconTheme = {
      name = "ePapirus";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Canvas";
    };
    theme = {
      name = "catppuccin-latte-lavender-standard+default";
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=0
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=0
      '';
    };
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}

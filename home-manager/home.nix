{ inputs
, lib
, config
, pkgs
, ...
}:
let
  spinny = import ../packages/spinny {
    inherit pkgs;
  };
  canvas-bibata = import ../themes/canvas-bibata {
    inherit pkgs;
  };
    canvas-gtk = import ../themes/canvas-gtk {
    inherit pkgs;
  };
in
{
  imports = [
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

  home.packages = with pkgs; [
    alsa-utils
    musescore
    obsidian
    mpv
    kitty
    wofi
    brightnessctl
    spotify
    hyprlock
    tree
    p7zip
    ags
    upower
    pavucontrol
    swww
    fastfetch
    firefox-wayland
    direnv
    vscode
    git
    nemo
    wf-recorder
    nvim-pkg
    nwg-look
    nixpkgs-fmt

    spinny
    canvas-bibata
    canvas-gtk
  ];

  programs = {
    home-manager = {
      enable = true;
    };
    git = {
      enable = true;
      userEmail = "localghost385@gmail.com";
      userName = "Grace Murphy";
      extraConfig = {
        core = {
          editor = "${pkgs.vscode}/bin/code --wait";
        };
        init = {
          defaultBranch = "main";
        };
        credential = {
          helper = "oauth";
        };
      };
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
      name = "canvas-bibata";
    };
    theme = {
      name = "catppuccin-latte-lavender-standard+rimless";
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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}

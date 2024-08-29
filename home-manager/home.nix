# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # }
      inputs.canvas-nvim.overlays.default
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "grace";
    homeDirectory = "/home/grace";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
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
    rustup
    ags
    upower
    pavucontrol
    swww
    fastfetch
    firefox-wayland
    vscode
    git
    nvim-pkg
  ];

  # Enable home-manager and git
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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}

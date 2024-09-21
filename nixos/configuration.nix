# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs
, lib
, config
, pkgs
, ...
}:
let
  canvas-grub = import ../packages/canvas-grub {
    inherit pkgs;
  };
in
{
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
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
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Opinionated: disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
      };
      # Opinionated: disable channels
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
        theme = "${canvas-grub}/share/grub/themes/apple";
      };
    };
  };

  time = {
    timeZone = "Europe/Dublin";
  };

  i18n = {
    defaultLocale = "en_IE.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_IE.UTF-8";
      LC_IDENTIFICATION = "en_IE.UTF-8";
      LC_MEASUREMENT = "en_IE.UTF-8";
      LC_MONETARY = "en_IE.UTF-8";
      LC_NAME = "en_IE.UTF-8";
      LC_NUMERIC = "en_IE.UTF-8";
      LC_PAPER = "en_IE.UTF-8";
      LC_TELEPHONE = "en_IE.UTF-8";
      LC_TIME = "en_IE.UTF-8";
    };
  };

  hardware = {
    pulseaudio = {
      enable = true; # Ensure PulseAudio is enabled
    };
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    zsh = {
      enable = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [ ];
  };

  fonts =
    if (config.system.nixos.release == 23.05)
    then {
      fonts = with pkgs; [
        (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
      ];
    }
    else {
      packages = with pkgs; [
        (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
      ];
    };

  networking = {
    hostName = "grace-nixos";
    networkmanager = {
      enable = true;
    };
  };
  users.users = {
    grace = {
      isNormalUser = true;
      description = "Grace Murphy";
      shell = pkgs.zsh;
      packages = with pkgs; [ ];
      extraGroups = [ "networkmanager" "wheel" "audio" ];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        # Opinionated: use keys only.
        # Remove if you want to SSH using passwords
        PasswordAuthentication = false;
      };
    };
    upower = {
      enable = true;
    };
    pipewire = {
      enable = false; # Ensure PipeWire is disabled
      alsa.enable = false;
      pulse.enable = false; # Ensure PipeWire's PulseAudio replacement is disabled
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

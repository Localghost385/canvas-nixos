{ inputs
, lib
, config
, pkgs
, ...
}:
let
  canvas-grub = import ../themes/canvas-grub {
    inherit pkgs;
  };
  canvas-sddm = import ../themes/canvas-sddm {
    inherit pkgs;
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  virtualisation.virtualbox.host.enable = true;

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = "nix-command flakes";
        flake-registry = "";
        nix-path = config.nix.nixPath;
      };
      channel.enable = false;

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
        theme = "${canvas-grub}/share/grub/themes/canvas-grub";
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
    systemPackages = with pkgs; [ 
      canvas-sddm
    ];
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

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    upower = {
      enable = true;
    };
    pipewire = {
      enable = false;
      alsa.enable = false;
      pulse.enable = false;
    };
    displayManager = {
      sddm = {
        wayland = {
          enable = true;
        };
        enable = true;
        theme = "canvas-sddm";
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim config
    canvas-nvim = {
      url = "github:Localghost385/canvas.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # canvas-bibata flake
    canvas-bibata = {
      url = "github:Localghost385/canvas-bibata";
      inputs.nixpkgs.follows = "nixpkgs"; # Optional, follow nixpkgs input
    };
  };

  outputs = { self, nixpkgs, home-manager, canvas-bibata, ... } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    nixosConfigurations = {
      grace-nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./nixos/configuration.nix
          ./nixos/hardware-configuration.nix  # Hardware configuration
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    homeConfigurations = {
      "grace@grace-nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [
          ./home-manager/home.nix  # Use the canvas-bibata in home-manager
        ];
      };
    };
  };
}

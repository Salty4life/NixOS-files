{
  description = "Salty's nixos config";

  inputs = {
    # Nixpkgs
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # NixOS Hardware
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # VSCode Extensions
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Catppuccin
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Catppucin Userstyles - Thank u Diffy!
    #    catppuccin-userstyles-nix = {
    #      url = "github:different-name/catppuccin-userstyles-nix";
    #      inputs.nixpkgs.follows = "nixpkgs";
    #    };

    # Nixpkgs XR
    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix User Repository
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      padora-mobile = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          self = inputs.self;
        };
        # > Our main nixos configuration file <
        modules = [
          ./system/configuration.nix
        ];
      };
    };
  };
}

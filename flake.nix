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
    catppuccin-userstyles-nix = {
      url = "github:different-name/catppuccin-userstyles-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    # MoonLight
    moonlight = {
      url = "github:moonlight-mod/moonlight"; # Add `/develop` to the flake URL to use nightly.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # import modules recursively
    import-tree.url = "github:vic/import-tree";

    # manage steam game launch options and other local config
    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    nixosModules.alcaide = inputs.import-tree ./alcaide/nixos;
    homeModules.alcaide = inputs.import-tree ./alcaide/home;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      nau = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          self = inputs.self;
        };
        # > Our main nixos configuration file <
        modules = [
          (inputs.import-tree ./hosts/nau)
        ];
      };

      padort = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          self = inputs.self;
        };
        # > Our main nixos configuration file <
        modules = [
          (inputs.import-tree ./hosts/padort)
        ];
      };
    };
  };
}

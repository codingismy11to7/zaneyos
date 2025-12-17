{
  description = "ZaneyOS";

  inputs = {
    systems.url = "github:nix-systems/default-linux";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";

    nvim = {
      url = "github:codingismy11to7/nvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Checking nixvim to see if it's better
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    # Google Antigravity (IDE)
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixvim,
    nix-flatpak,
    systems,
    ...
  } @ inputs: let
    username = "steven";

    forAllSystems = nixpkgs.lib.genAttrs (import systems);

    # Deduplicate nixosConfigurations while preserving the top-level 'profile'
    mkNixosConfig = host:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit username;
        };
        modules = [
          ./modules/core
          ./modules/drivers
          inputs.sops-nix.nixosModules.sops
          ./hosts/${host}
          ./profiles
        ];
      };

    hosts = [
      "nixowsl"
      "nixstation"
      "zaneyos-24-vm"
      "zaneyos-oem"
    ];
  in {
    nixosConfigurations = builtins.listToAttrs (map (host: {
        name = host;
        value = mkNixosConfig host;
      })
      hosts);

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}

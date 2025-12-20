{
  description = "ZaneyOS";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix/release-25.11";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Checking nixvim to see if it's better
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Google Antigravity (IDE)
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixvim,
    nix-flatpak,
    alejandra,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "dwilliams";

    # Deduplicate nixosConfigurations while preserving the top-level 'profile'
    mkNixosConfig = host:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
        };
        modules = [
          ./modules/core
          ./modules/drivers
          nix-flatpak.nixosModules.nix-flatpak
          ./hosts/${host}
          ./profiles
        ];
      };

    hosts = [
      "default"
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

    formatter.x86_64-linux = inputs.alejandra.packages.x86_64-linux.default;
  };
}

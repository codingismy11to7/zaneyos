{
  description = "ZaneyOS";

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO: this part i think is going to dictate two different flakes?
    nixpkgs.url = "github:nvmd/nixpkgs/modules-with-keys-25.11";
    nixpkgs-unstable.url = "github:nvmd/nixpkgs/modules-with-keys-unstable";
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix/release-25.11";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
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

  outputs =
    {
      nixpkgs,
      nixos-raspberrypi,
      disko,
      home-manager,
      nixvim,
      nix-flatpak,
      alejandra,
      ...
    }@inputs:
    let
      host = "rpi5plus";
      profile = "rpi5plus";
      username = "steven";

      # Deduplicate nixosConfigurations while preserving the top-level 'profile'
      mkNixosConfig =
        gpuProfile:
        let
          lib = if gpuProfile == "rpi5plus" then nixos-raspberrypi.lib else nixpkgs.lib;
        in
        lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit nixos-raspberrypi;
            inherit username;
            inherit host;
            inherit profile; # keep using the let-bound profile for modules/scripts
          };
          modules = [
            ./modules/core/overlays.nix
            ./profiles/${gpuProfile}
            nix-flatpak.nixosModules.nix-flatpak
          ];
        };
    in
    {
      nixosConfigurations = {
        amd = mkNixosConfig "amd";
        nvidia = mkNixosConfig "nvidia";
        nvidia-laptop = mkNixosConfig "nvidia-laptop";
        amd-hybrid = mkNixosConfig "amd-hybrid";
        intel = mkNixosConfig "intel";
        vm = mkNixosConfig "vm";
        rpi5plus = mkNixosConfig "rpi5plus";
      };

      formatter.x86_64-linux = inputs.alejandra.packages.x86_64-linux.default;
    };
}

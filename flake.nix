{
  description = "ZaneyOS";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix/release-25.05";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";

    # Hypersysinfo
    hyprsysteminfo.url = "github:hyprwm/hyprsysteminfo";

    # QuickShell
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nix-flatpak,
    quickshell,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "dwilliams";

    # Host configurations - define each host and its profile here
    hosts = {
      zaneyos-oem = {
        profile = "vm";
      };
      default = {
        profile = "intel";
      };
      nixstation = {
        profile = "nvidia-laptop";
      };
      # example of adding an additional host
      # my-laptop = {
      #   profile = "nvidia-laptop";
      # };
    };

    mkHost = hostName: hostConfig: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit username;
        host = hostName;
        profile = hostConfig.profile;
      };
      modules = [
        ./profiles/${hostConfig.profile}
        nix-flatpak.nixosModules.nix-flatpak
      ];
    };
  in {
    nixosConfigurations = builtins.mapAttrs mkHost hosts;
  };
}

{ inputs, pkgs, ... }:
{
  omarchy = {
    enable = true;
    hyprland.package = pkgs.unstable.hyprland;
  };

  imports = [
    inputs.omarchy.nixosModules.default
    ../options.nix
    ./boot.nix
    ./flatpak.nix
    ./fonts.nix
    ./hardware.nix
    ./nautilus.nix
    ./network.nix
    ./nfs.nix
    ./nh.nix
    ./nix.nix
    ./quickshell.nix
    ./overlays.nix
    ./packages.nix
    ./printing.nix
    ./ly.nix
    ./sddm.nix
    ./security.nix
    ./services.nix
    ./steam.nix
    # ./stylix.nix
    ./syncthing.nix
    ./system.nix
    ./thunar.nix
    ./user.nix
    ./virtualisation.nix
    ./xserver.nix
    ./ydotool.nix
    # inputs.stylix.nixosModules.stylix
  ];
}

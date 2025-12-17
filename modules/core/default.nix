{
  inputs,
  host,
  ...
}: let
  # Import the host-specific variables.nix
  vars = import ../../hosts/${host}/variables.nix;
in {
  imports = [
    ./boot.nix
    ./flatpak.nix
    ./fonts.nix
    ./hardware.nix
    ./nautilus.nix
    ./network.nix
    ./nfs.nix
    ./nh.nix
    # ./quickshell.nix
    ./packages.nix
    ./printing.nix
    # Conditionally import the display manager module
    # (
    #   if vars.displayManager == "tui"
    #   then ./ly.nix
    #   else ./sddm.nix
    # )
    ./security.nix
    ./services.nix
    ./ssh-agent.nix
    # ./steam.nix
    ./stylix.nix
    ./syncthing.nix
    ./system.nix
    ./thunar.nix
    ./user.nix
    ./virtualisation.nix
    ./xserver.nix
    # ./ydotool.nix
    ./cachix.nix
    inputs.stylix.nixosModules.stylix
  ];
}

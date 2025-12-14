{
  host,
  lib,
  pkgs,
  ...
}: let
  inherit (import ../../hosts/${host}/variables.nix) nautilusEnable;
in
  lib.mkIf nautilusEnable {
    # quick preview for nautilus
    services.gnome.sushi.enable = true;

    environment.systemPackages = with pkgs; [
      nautilus
    ];
  }

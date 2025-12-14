{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.zaneyos.nautilusEnable {
  # quick preview for nautilus
  services.gnome.sushi.enable = true;

  environment.systemPackages = with pkgs; [
    nautilus
  ];
}

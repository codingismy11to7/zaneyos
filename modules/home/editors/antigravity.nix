{
  lib,
  pkgs,
  zaneyos,
  ...
}:
lib.mkIf zaneyos.antigravityEnable {
  # Google Antigravity IDE helper, exposed via antigravity-nix overlay as pkgs.google-antigravity
  home.packages = with pkgs; [
    google-antigravity
  ];
}

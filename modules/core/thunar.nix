{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.zaneyos.thunarEnable {
  services.tumbler.enable = true; # Image/video preview

  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
  environment.systemPackages = with pkgs; [
    ffmpegthumbnailer # Need For Video / Image Preview
  ];
}

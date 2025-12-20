{
  config,
  pkgs,
  ...
}: let
  inherit (config.zaneyos) scannerEnable;
in {
  hardware = {
    sane = {
      enable = scannerEnable;
      extraBackends = [pkgs.sane-airscan];
      disabledDefaultBackends = ["escl"];
    };
    logitech.wireless.enable = false;
    logitech.wireless.enableGraphical = false;
    graphics.enable = true;
    enableRedistributableFirmware = true;
    keyboard.qmk.enable = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };
  local.hardware-clock.enable = false;
}

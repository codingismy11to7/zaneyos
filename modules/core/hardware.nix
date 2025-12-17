{
  host,
  pkgs,
  ...
}: let
  # Import the host-specific variables.nix
  inherit (import ../../hosts/${host}/variables.nix) scannerEnable;
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
    enableRedistributableFirmware = false;
    keyboard.qmk.enable = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };
  local.hardware-clock.enable = false;
}

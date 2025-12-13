{ host, pkgs, ... }:
let
  # Import the host-specific variables.nix
  vars = import ../../hosts/${host}/variables.nix;
in
{
  hardware = {
    sane = {
      enable = vars.scannerEnable;
      extraBackends = [ pkgs.sane-airscan ];
      disabledDefaultBackends = [ "escl" ];
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

{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  package =
    if (!pkgs.stdenv.hostPlatform.isx86_64)
    then pkgs.btop
    else
      pkgs.btop.override {
        rocmSupport = true;
        cudaSupport = true;
      };
in {
  programs.btop = {
    enable = true;
    inherit package;
    settings = {
      vim_keys = true;
      rounded_corners = true;
      proc_tree = true;
      show_gpu_info = "on";
      show_uptime = true;
      show_coretemp = true;
      cpu_sensor = "auto";
      show_disks = true;
      only_physical = true;
      io_mode = true;
      io_graph_combined = false;
    };
  };
}

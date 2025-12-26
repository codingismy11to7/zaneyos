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
      proc_tree = false;
      proc_filter_kernel = true;
      show_gpu_info = "on";
      io_mode = true;
    };
  };
}

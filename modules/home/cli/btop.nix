{pkgs, ...}: {
  programs.btop = {
    enable = true;
    package = pkgs.btop.override {
      rocmSupport = true;
      cudaSupport = true;
    };
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

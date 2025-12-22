{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.zaneyos.gpuProfile == "nvidia") {
    drivers = {
      # Enable GPU Drivers
      amdgpu.enable = false;
      nvidia.enable = true;
      nvidia-prime.enable = false;
      intel.enable = false;
    };
    vm.guest-services.enable = false;
  };
}


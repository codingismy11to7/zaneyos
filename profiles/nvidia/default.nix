{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.zaneyos.gpuProfile == "nvidia") {
    # Enable GPU Drivers
    drivers.amdgpu.enable = false;
    drivers.nvidia.enable = true;
    drivers.nvidia-prime.enable = false;
    drivers.intel.enable = false;
    vm.guest-services.enable = false;
  };
}

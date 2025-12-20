{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.zaneyos.gpuProfile == "vm") {
    # Enable GPU Drivers
    drivers.amdgpu.enable = false;
    drivers.nvidia.enable = false;
    drivers.nvidia-prime.enable = false;
    drivers.intel.enable = false;
    vm.guest-services.enable = true;
  };
}
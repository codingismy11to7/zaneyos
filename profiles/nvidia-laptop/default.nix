{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.zaneyos.gpuProfile == "nvidia-laptop") {
    # Enable GPU Drivers
    drivers.amdgpu.enable = false;
    drivers.nvidia.enable = true;
    drivers.nvidia-prime = {
      enable = true;
      intelBusID = config.zaneyos.intelID;
      nvidiaBusID = config.zaneyos.nvidiaID;
    };
    drivers.intel.enable = false;
    vm.guest-services.enable = false;
  };
}
{ host, inputs, ... }:
{
  imports =
    with inputs.nixos-raspberrypi.nixosModules;
    [
      raspberry-pi-5.base
      raspberry-pi-5.page-size-16k
      raspberry-pi-5.display-vc4
      raspberry-pi-5.bluetooth
    ]
    ++ [
      ../../hosts/${host}
      ../../modules/drivers
      ../../modules/core
    ];
  # Enable GPU Drivers
  drivers = {
    amdgpu.enable = false;
    nvidia.enable = false;
    nvidia-prime.enable = false;
    intel.enable = false;
  };
  vm.guest-services.enable = false;
}

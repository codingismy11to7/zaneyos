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

  system.activationScripts.postBootloader = ''
    echo "Running post-bootloader script..."
    echo "Manually doing boot config stuff..."

    DIR=$(mktemp -d)
    mount /dev/nvme0n1p2 $DIR

    # Define target directory for the 'default' generation
    TARGET="$DIR/firmware/nixos/default"

    # Clear existing nixos directory on target and recreate
    rm -rf "$DIR/firmware/nixos"
    mkdir -p "$TARGET"

    # Copy Kernel (renaming to kernel.img as expected by RPi bootloader setup)
    cp -L "$systemConfig/kernel" "$TARGET/kernel.img"

    # Copy Initrd
    cp -L "$systemConfig/initrd" "$TARGET/initrd"

    # Copy DTBs and Overlays (recursively)
    # $systemConfig/dtbs/ usually contains .dtb files and an overlays/ subdirectory
    cp -rL "$systemConfig/dtbs/"* "$TARGET/"

    # Copy Kernel Parameters to cmdline.txt
    if [ -f "$systemConfig/kernel-params" ]; then
      cp -L "$systemConfig/kernel-params" "$TARGET/cmdline.txt"
    else
      echo "Warning: kernel-params not found in systemConfig, cmdline.txt will be missing!"
    fi

    umount $DIR

  '';
}

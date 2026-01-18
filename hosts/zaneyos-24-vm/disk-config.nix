{
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = ["/"];
  };

  disko.devices = {
    disk.vmdisk = {
      type = "disk";
      device = "/dev/vda";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            end = "2048M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "vmdisk";
              # disable settings.keyFile if you want to use interactive password entry
              passwordFile = "/tmp/secret.key"; # Interactive
              settings = {
                allowDiscards = true;
                # keyFile = "/boot/crypto_keyfile.bin";
              };
              #additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "noatime"
                    ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "noatime"
                    ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "noatime"
                    ];
                  };
                  "/swap" = {
                    mountpoint = "/.swapvol";
                    swap."swapfile" = {
                      size = "6G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}

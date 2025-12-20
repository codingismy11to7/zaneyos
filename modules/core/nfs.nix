{config, ...}: let
  inherit (config.zaneyos) enableNFS;
in {
  services = {
    rpcbind.enable = enableNFS;
    nfs.server.enable = enableNFS;
  };
}


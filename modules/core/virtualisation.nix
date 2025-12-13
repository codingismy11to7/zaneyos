{ pkgs, ... }:
{
  # Only enable either docker or podman -- Not both
  virtualisation = {
    docker = {
      enable = false;
    };

    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    libvirtd = {
      enable = true;
    };

    virtualbox.host = {
      enable = false;
      enableExtensionPack = true;
    };
  };

  programs = {
    virt-manager.enable = false;
  };

  environment.systemPackages =
    (with pkgs.unstable; [
      distrobox
      distrobox-tui
      lazydocker
    ])
    ++ (with pkgs; [
      podman-compose
      virt-viewer # View Virtual Machines
      # docker-client
    ]);
}

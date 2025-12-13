{
  config,
  host,
  inputs,
  pkgs,
  username,
  ...
}: let
  inherit (config.zaneyos) gitUsername scannerEnable;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = {
      inherit
        inputs
        username
        host
        pkgs
        ;
      inherit (config) zaneyos;
    };
    users.${username} = {
      imports = [../home];
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
        stateVersion = "23.11";
      };
    };
  };
  users = {
    mutableUsers = false;

    users.root.hashedPasswordFile = config.sops.secrets.unixRootPassword.path;

    users.${username} = {
      hashedPasswordFile = config.sops.secrets.unixPassword.path;
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "adbusers"
        "docker" # access to docker as non-root
        "libvirtd" # Virt manager/QEMU access
        "lp"
        "networkmanager"
        "wheel" # sudo access
        "vboxusers" # Virtual Box
      ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxNSrwubJSzASpdG2Tb2KuqCwfv0QQHtSEySnDlxycPrtQf1LUNyItrGxBXUPf0b3lALV64DAOSoko8w2WbiwqUcQKnDAN5uOtxgO+bCprzEsyI7eIH/xUkG2p/xX3VNxaJQVnvgfesLuiJNfVdupbKFDO7xVJ2ByfViiG8EP9cBv3a62yu6bDnqyh8fXy0YTtxu6iPhQ46kt5rr2OaaKgOacokYwmJ2OW43j/GnFPpUueyRH3Zk5X7nSFbySTKUmnPjHkh4vUTcvxyEPpT1g01JOmvdVx9eCLsB0wx8Pxso1d7Nd5u+D+e7c3LWLWddw1TKwFfO5GLRHXA4fsyKSew=="
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxJhslVg1p7z/RcbMefJHoyyazS0c91U1MKBgVQrtuy"
      ];
      shell = pkgs.fish;
      ignoreShellProgramCheck = true;
    };
  };
  nix.settings = {
    allowed-users = [username];
    trusted-users = [username];
  };
}

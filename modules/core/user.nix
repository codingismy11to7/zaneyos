{
  pkgs,
  inputs,
  username,
  host,
  profile,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) gitUsername;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = {
      inherit
        inputs
        username
        host
        profile
        pkgs
        ;
    };
    users.${username} = {
      imports = [ ../home ];
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
        stateVersion = "23.11";
      };
    };
  };
  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = [
      "adbusers"
      "docker" # access to docker as non-root
      "libvirtd" # Virt manager/QEMU access
      "lp"
      "networkmanager"
      "scanner"
      "wheel" # sudo access
      "vboxusers" # Virtual Box
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxNSrwubJSzASpdG2Tb2KuqCwfv0QQHtSEySnDlxycPrtQf1LUNyItrGxBXUPf0b3lALV64DAOSoko8w2WbiwqUcQKnDAN5uOtxgO+bCprzEsyI7eIH/xUkG2p/xX3VNxaJQVnvgfesLuiJNfVdupbKFDO7xVJ2ByfViiG8EP9cBv3a62yu6bDnqyh8fXy0YTtxu6iPhQ46kt5rr2OaaKgOacokYwmJ2OW43j/GnFPpUueyRH3Zk5X7nSFbySTKUmnPjHkh4vUTcvxyEPpT1g01JOmvdVx9eCLsB0wx8Pxso1d7Nd5u+D+e7c3LWLWddw1TKwFfO5GLRHXA4fsyKSew=="
    ];
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  };
  nix.settings = {
    allowed-users = [ username ];
    trusted-users = [ username ];
  };
}

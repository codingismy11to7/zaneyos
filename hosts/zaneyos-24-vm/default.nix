{...}: {
  imports = [
    ./configuration.nix
    ./disk-config.nix
    {hardware.facter.reportPath = ./facter.json;}
    ./host-packages.nix
  ];
}

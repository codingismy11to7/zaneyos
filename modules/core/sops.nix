{
  config,
  username,
  ...
}: {
  sops = {
    defaultSopsFile = ../../secrets/secrets.json;
    defaultSopsFormat = "json";

    age.keyFile = config.zaneyos.sopsKeyFile;

    secrets = {
      unixPassword = {
        neededForUsers = true;
      };
      unixRootPassword = {
        neededForUsers = true;
      };
    };
  };

  # When running in a VM (via nh os build-vm), mount the sops directory
  # so sops can access the key.
  virtualisation.vmVariant = {
    virtualisation.sharedDirectories = {
      secrets = {
        source = "/home/${username}/zaneyos/secrets";
        target = "/home/${username}/zaneyos/secrets";
      };

      sops-keys = {
        source = dirOf config.zaneyos.sopsKeyFile;
        target = dirOf config.zaneyos.sopsKeyFile;
      };
    };
  };
}

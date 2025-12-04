{
  config,
  inputs,
  zaneyos,
  ...
}: let
  ageKeyFile = zaneyos.sopsKeyFile;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.keyFile = ageKeyFile;
    defaultSopsFile = ./secrets.yaml;

    secrets.sshPrivKey = {
      path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      mode = "0600";
    };

    secrets.githubNixToken = {};
    templates."nix.conf".content = ''
      access-tokens = github.com=${config.sops.placeholder.githubNixToken}
    '';
  };

  home.sessionVariables.SOPS_AGE_KEY_FILE = ageKeyFile;

  xdg.configFile."nix/nix.conf".source =
    config.lib.file.mkOutOfStoreSymlink
    config.sops.templates."nix.conf".path;
}

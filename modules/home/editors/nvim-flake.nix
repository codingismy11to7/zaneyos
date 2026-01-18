{
  config,
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    (inputs.nvim.lib.mkNeovim {
      pkgs = pkgs.unstable;
      inherit (pkgs.stdenv.hostPlatform) system;
      theme = {
        content = inputs.omarchy.lazyvimTheme.default {inherit config;};
      };
    })
  ];
}

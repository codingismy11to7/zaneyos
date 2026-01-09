{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    (inputs.nvim.lib.mkNeovim {
      pkgs = pkgs.unstable;
      inherit (pkgs.stdenv.hostPlatform) system;
      theme = {
        content = ''
          return {
            { "bjarneo/ethereal.nvim" },
            { "LazyVim/LazyVim", opts = { colorscheme = "ethereal" } },
          }
        '';
      };
    })
  ];
}

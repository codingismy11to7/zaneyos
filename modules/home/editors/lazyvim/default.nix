{
  config,
  pkgs,
  ...
}:
{
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/zaneyos/modules/home/editors/lazyvim/config";

  home.packages =
    let
      stablePkgs = with pkgs; [
        cargo
        gcc
        nodejs
      ];
      unstablePkgs = with pkgs.unstable; [
        fd
        fzf
        neovim
        nil
        nixfmt-rfc-style
        ripgrep
        statix
        tree-sitter
      ];
    in
    stablePkgs ++ unstablePkgs;
}

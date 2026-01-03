{zaneyos, ...}: let
  inherit (zaneyos) barChoice waybarChoice;

  # Select bar module based on barChoice
  barModule =
    if barChoice == "noctalia"
    then ./noctalia.nix
    else waybarChoice;
in {
  home.sessionVariables.EDITOR = "nvim";

  imports = [
    ./terminals/alacritty.nix
    ./amfora.nix
    ./editors/antigravity.nix
    ./bash.nix
    ./bashrc-personal.nix
    ./nix-your-shell.nix
    ./overview.nix
    ./python.nix
    ./cli/bat.nix
    ./cli/btop.nix
    # ./cli/bottom.nix
    ./cli/cava.nix
    ./direnv.nix
    ./editors/doom-emacs.nix
    ./editors/doom-emacs-install.nix
    ./emoji.nix
    ./editors/evil-helix.nix
    ./eza.nix
    ./fastfetch
    ./fish
    ./cli/fzf.nix
    ./cli/gh.nix
    ./terminals/ghostty.nix
    ./cli/git.nix
    ./gtk.nix
    # ./cli/htop.nix
    ./hyprland
    ./terminals/kitty.nix
    ./cli/lazygit.nix
    ./obs-studio.nix
    ./editors/lazyvim
    #./editors/nvf.nix
    # ./editors/nixvim.nix
    ./editors/nano.nix
    ./rofi
    ./qt.nix
    ./scripts
    # ./scripts/gemini-cli.nix
    ../../secrets/sops.nix
    ./stylix.nix
    ./swappy.nix
    ./swaync.nix
    ./tealdeer.nix
    ./terminals/tmux.nix
    ./virtmanager.nix
    ./editors/vscode.nix
    barModule
    ./webapps
    ./terminals/wezterm.nix
    ./wlogout
    ./xdg.nix
    ./yazi
    # ./zen-browser.nix
    ./zoxide.nix
    ./zsh
  ];
}

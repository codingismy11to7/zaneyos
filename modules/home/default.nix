{
  inputs,
  pkgs,
  zaneyos,
  ...
}: let
  inherit (zaneyos) barChoice browser waybarChoice;

  # Select bar module based on barChoice
  barModule =
    if barChoice == "noctalia"
    then ./noctalia.nix
    else waybarChoice;
in {
  home.sessionVariables.EDITOR = "nvim";

  omarchy = {
    enable = true;
    inherit browser;
    theme = "ethereal";
    firstRunMode = false;
    font.name = "FiraCode Nerd Font";
    font.package = pkgs.nerd-fonts.fira-code;
    keyboard = {
      layout = zaneyos.keyboardLayout;
      variant = zaneyos.keyboardVariant;
      options = "compose:ralt";
    };
    hyprland = {
      package = pkgs.unstable.hyprland;
      monitorConfig = ''
        env = GDK_SCALE,1.5
        monitor=,preferred,auto,1.6,bitdepth,10
      '';
      widerWindowGaps = true;
      # roundWindowCorners = true;
      dwindleExtra = "single_window_aspect_ratio = 16 9";
      bindingsExtra = ''
        bindd = CTRL, F11, Melt Faces, exec, repeat_key_toggle
      '';
      envsExtra = ''
        env = YDOTOOL_SOCKET,/run/ydotool/socket
      '';
    };
    passwordManager = "bitwarden";
    screensaver = {
      activationMinutes = 5;
      lockMinutes = 15;
      screenOffDelaySeconds = 60;
    };
  };

  imports = [
    inputs.omarchy.homeManagerModules.default
    ./terminals/alacritty.nix
    ./amfora.nix
    ./editors/antigravity.nix
    ./bash.nix
    ./bashrc-personal.nix
    ./nix-your-shell.nix
    ./overview.nix
    ./python.nix
    ./cli/bat.nix
    # ./cli/btop.nix
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
    # ./gtk.nix
    # ./cli/htop.nix
    # ./hyprland
    # ./terminals/kitty.nix
    ./cli/lazygit.nix
    ./obs-studio.nix
    # ./editors/lazyvim
    #./editors/nvf.nix
    # ./editors/nixvim.nix
    ./editors/nvim-flake.nix
    ./editors/nano.nix
    # ./rofi
    # ./qt.nix
    ./scripts
    # ./scripts/gemini-cli.nix
    # ./stylix.nix
    ./swappy.nix
    # ./swaync.nix
    ./tealdeer.nix
    ./terminals/tmux.nix
    ./virtmanager.nix
    ./editors/vscode.nix
    # barModule
    ./webapps
    ./terminals/wezterm.nix
    # ./wlogout
    ./xdg.nix
    ./yazi
    ./zellij
    # ./zen-browser.nix
    ./zoxide.nix
    ./zsh
  ];
}

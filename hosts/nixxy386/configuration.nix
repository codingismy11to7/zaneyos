_: {
  # Welcome to your ZaneyOS configuration!
  # This block is where you can customize your NixOS experience.
  #
  # For a comprehensive list of all available options, their descriptions,
  # and default values, please refer to the following file:
  # ../../modules/options.nix
  #
  # You can override any of those options here. Most settings are optional
  # and can be removed to use the project defaults.
  zaneyos = {
    # Git Configuration
    gitUsername = "Steven Scott";
    gitEmail = "steven@codemettle.com";

    # does not have to be the same as the directory name, but
    # would be common
    hostName = "nixxy386";

    gpuProfile = "nvidia";

    # Set Display Manager
    # `tui` for Text login
    # `sddm` for graphical GUI (default)
    # SDDM background is set with stylixImage
    displayManager = "sddm";

    # Emable/disable bundled applications
    tmuxEnable = false;
    alacrittyEnable = false;
    weztermEnable = false;
    ghosttyEnable = false;
    vscodeEnable = false;
    antigravityEnable = false; # Google port of vscodium
    # Note: This is evil-helix with VIM keybindings by default
    helixEnable = false;
    #To install: Enable here, zcli rebuild, then run zcli doom install
    doomEmacsEnable = false;

    # Bar/Shell Settings
    # Choose between noctalia or waybar
    barChoice = "waybar";

    # Waybar Settings (used when barChoice = "waybar")
    clock24h = false;

    # Program Options
    # Set Default Browser (google-chrome-stable for google-chrome)
    # This does NOT install your browser
    # You need to install it by adding it to the `packages.nix`
    # or as a flatpak
    browser = "brave";

    # Available Options:
    # Kitty, ghostty, wezterm, aalacrity
    # Note: kitty, wezterm, alacritty have to be enabled in `variables.nix`
    # Setting it here does not enable it. Kitty is installed by default
    terminal = "ghostty"; # Set Default System Terminal

    keyboardLayout = "us";
    keyboardVariant = "dvorak";
    consoleKeyMap = "dvorak";

    enableNFS = false;

    enableGnuPGAgent = false;
    scannerEnable = false;
    nautilusEnable = false;
    obsStudioEnable = false;
  };
}

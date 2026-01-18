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
    # Git Configuration ( For Pulling Software Repos )
    gitUsername = "dwilliams";
    gitEmail = "don.e.williams@gmail.com";

    hostName = "zaneyos-24-vm";

    enableSmartD = false;

    gpuProfile = "vm";

    # Set Displau Manager
    # `tui` for Text login
    # `sddm` for graphical GUI (default)
    # SDDM background is set with stylixImage
    displayManager = "tui";

    # Emable/disable bundled applications
    tmuxEnable = true;
    alacrittyEnable = false;
    weztermEnable = true;
    ghosttyEnable = false;
    vscodeEnable = false;
    antigravityEnable = false; # Google port of vscodium
    # Note: This is evil-helix with VIM keybindings by default
    # helixEnable = true;
    #To install: Enable here, zcli rebuild, then run zcli doom install
    # doomEmacsEnable = true;

    # Python development tools
    pythonEnable = false;

    obsStudioEnable = false;

    # Hyprland Settings
    # Examples:
    # extraMonitorSettings = "monitor = Virtual-1,1920x1080@60,auto,1";
    # extraMonitorSettings = "monitor = HDMI-A-1,1920x1080@60,auto,1";
    # You can configure multiple monitors.
    # Inside the quotes, create a new line for each monitor.
    extraMonitorSettings = "

    ";

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
    terminal = "kitty"; # Set Default System Terminal

    keyboardLayout = "us";
    keyboardVariant = "dvorak";
    consoleKeyMap = "dvorak";

    # For hybrid support (Intel/NVIDIA Prime or AMD/NVIDIA)
    intelID = "PCI:1:0:0";
    amdgpuID = "PCI:5:0:0";
    nvidiaID = "PCI:0:2:0";

    # Enable NFS
    enableNFS = true;

    # Enable Printing Support
    printEnable = false;

    # Enable Thunar GUI File Manager
    # Yazi is default File Manager
    thunarEnable = true;
  };
}

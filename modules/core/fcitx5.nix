{ pkgs, ... }: {
  i18n.inputMethod = {
    type = "fcitx5";
    enable = false;
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-nord            # a color theme
        fcitx5-chinese-addons
        fcitx5-configtool
        fcitx5-gtk
        fcitx5-with-addons
      ];
      # Enable Wayland frontend for better Hyprland compatibility
      waylandFrontend = true;
    };
  };

  # Environment variables to ensure fcitx5 works correctly with Wayland/Hyprland
  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus"; # Helps with some apps that use GLFW
  };

  # Add related packages
  environment.systemPackages = with pkgs; [
    libsForQt5.fcitx5-qt
  ];
} 
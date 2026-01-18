# SDDM is a display manager for X11 and Wayland
{
  pkgs,
  config,
  lib,
  ...
}: let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
    themeConfig = {
      FormPosition = "left";
      Blur = "4.0";
      # Background = "${toString config.stylix.image}";
      HourFormat = "h:mm AP";
    };
  };
in {
  config = lib.mkIf (config.zaneyos.displayManager == "sddm") {
    services.displayManager = {
      sddm = {
        package = pkgs.kdePackages.sddm;
        extraPackages = [sddm-astronaut];
        enable = true;
        wayland.enable = true;
        theme = "sddm-astronaut-theme";
        settings = let
          keyboardLayout = config.zaneyos.keyboardLayout;
          keyboardVariant = config.zaneyos.keyboardVariant;
        in {
          X11 = {
            XkbLayout = keyboardLayout;
            XkbVariant = keyboardVariant;
          };
        };
      };
    };

    # Ensure Wayland SDDM also sees XKB defaults
    systemd.services.display-manager.environment = let
      keyboardLayout = config.zaneyos.keyboardLayout;
      keyboardVariant = config.zaneyos.keyboardVariant;
    in ({XKB_DEFAULT_LAYOUT = keyboardLayout;}
      // lib.optionalAttrs (keyboardVariant != "") {XKB_DEFAULT_VARIANT = keyboardVariant;});

    environment.systemPackages = [sddm-astronaut];
  };
}


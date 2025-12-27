{
  programs.fastfetch = {
    enable = true;
  };

  # Install additional Fastfetch JSON configs used by ff* wrappers
  home.file = {
    ".config/fastfetch/fastfetch-system-times.config.jsonc".source = ./fastfetch-system-times.config.jsonc;
    ".config/fastfetch/fastfetch1.config.jsonc".source = ./fastfetch1.config.jsonc;
    ".config/fastfetch/fastfetch2.config.jsonc".source = ./fastfetch2.config.jsonc;
    ".config/fastfetch/fastfetch3.config.jsonc".source = ./fastfetch3.config.jsonc;
    ".config/fastfetch/fastfetch4.config.jsonc".source = ./fastfetch4.config.jsonc;
    ".config/fastfetch/fastfetch5.config.jsonc".source = ./fastfetch5.config.jsonc;
    # ".config/fastfetch/nixos.png".source = ./nixos.png;
  };
}

{ pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;
      useBabelfish = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # audacity
    # discord
    nodejs
  ];
}

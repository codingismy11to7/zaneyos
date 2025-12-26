{pkgs, ...}: {
  programs = {
    fish = {
      enable = true;
      useBabelfish = true;
    };
  };

  environment.systemPackages = let
    stable = with pkgs; [
      # audacity
      # discord
      nodejs
    ];
    unstable = with pkgs.unstable; [
      heroic
      plex-desktop
      plexamp
    ];
  in
    stable ++ unstable;
}

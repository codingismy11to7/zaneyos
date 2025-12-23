{
  pkgs,
  zaneyos,
  ...
}: {
  programs.obs-studio = {
    enable = zaneyos.obsStudioEnable;
    #enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      obs-vkcapture
      obs-source-clone
      obs-move-transition
      obs-composite-blur
      obs-backgroundremoval
    ];
  };
}

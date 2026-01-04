{pkgs, ...}: {
  xdg.configFile."zellij/plugins/zellij-autolock.wasm".source = pkgs.fetchurl {
    url = "https://github.com/fresh2dev/zellij-autolock/releases/download/0.2.2/zellij-autolock.wasm";
    sha256 = "69c95607bfd97e075d6762a44fdbc703a82a3c4909dbbbe43952f020487b8ea4";
  };

  xdg.configFile."zellij/config.kdl".source = ./config.kdl;

  programs.zellij = {
    enable = true;
    package = pkgs.unstable.zellij;
  };
}

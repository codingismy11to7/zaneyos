{
  config,
  pkgs,
  ...
}: let
  inherit (config.users.users) root;
  inherit (config.users.groups) wheel;
in {
  environment.systemPackages = [pkgs.unstable.ydotool];

  systemd.services.ydotoold = {
    description = "ydotoold - Synthesizing input device daemon";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Group = "wheel";
      RuntimeDirectory = "ydotool";
      RuntimeDirectoryMode = "0770";
      # make the socket ONLY accessible by root and wheel group
      ExecStart = "${pkgs.unstable.ydotool}/bin/ydotoold -p /run/ydotool/socket -P 0660 -o ${toString root.uid}:${toString wheel.gid}";
      Restart = "always";
    };
  };
}

{
  config,
  lib,
  ...
}: let
  makeDesktopFile = appName: appExec: iconPath: ''
    [Desktop Entry]
    Version=1.0
    Name=${appName}
    Comment=Launch ${appName}
    Exec=${appExec}
    Terminal=false
    Type=Application
    Icon=${iconPath}
    StartupNotify=true
  '';

  desktopFile = appName: "${config.xdg.dataHome}/applications/${lib.toLower appName}.desktop";

  makeLauncher = appName: appUrl: iconPath:
    makeDesktopFile appName "omarchy-launch-webapp ${appUrl}" iconPath;

  makeSingleton = appName: appUrl: iconPath:
    makeDesktopFile appName ''omarchy-launch-or-focus-webapp "${appName}" ${appUrl}'' iconPath;
in {
  home.file = {
    "${desktopFile "radarr"}".text = makeLauncher "Radarr" "https://radarr.codingismy11to7.us" ./icons/radarr.svg;
    "${desktopFile "sabnzbd"}".text = makeLauncher "SABnzbd" "https://sabnzbd.codingismy11to7.us" ./icons/sabnzbd.svg;
    "${desktopFile "sonarr"}".text = makeLauncher "Sonarr" "https://sonarr.codingismy11to7.us" ./icons/sonarr.svg;
    "${desktopFile "tautulli"}".text = makeLauncher "Tautulli" "https://tautulli.codingismy11to7.us" ./icons/tautulli.svg;

    "${desktopFile "gmail"}".text = makeSingleton "Gmail" "https://mail.google.com" ./icons/gmail.svg;
    "${desktopFile "google-calendar"}".text = makeSingleton "Google Calendar" "https://calendar.google.com" ./icons/google-calendar.svg;
    "${desktopFile "google-contacts"}".text = makeSingleton "Google Contacts" "https://contacts.google.com" ./icons/google-contacts.svg;
    "${desktopFile "google-drive"}".text = makeSingleton "Google Drive" "https://drive.google.com" ./icons/google-drive.svg;
    "${desktopFile "google-gemini"}".text = makeLauncher "Google Gemini" "https://gemini.google.com/app" ./icons/google-gemini.svg;
    "${desktopFile "google-messages"}".text = makeSingleton "Google Messages" "https://messages.google.com/web" ./icons/google-messages.svg;
    "${desktopFile "google-photos"}".text = makeSingleton "Google Photos" "https://photos.google.com" ./icons/google-photos.svg;
    "${desktopFile "plex-web-app"}".text = makeSingleton "Plex (Web App)" "https://app.plex.tv/desktop" ./icons/plex.svg;
  };
}

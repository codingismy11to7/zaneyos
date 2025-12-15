{
  pkgs,
  zaneyos,
  ...
}: let
  inherit
    (zaneyos)
    barChoice
    browser
    terminal
    ;

  launch-desktop-file = "${pkgs.gtk3}/bin/gtk-launch";

  # Noctalia-specific bindings (only included when barChoice == "noctalia")
  noctaliaBind =
    if barChoice == "noctalia"
    then [
      "$modifier,D, Noctalia Launcher, exec, noctalia-shell ipc call launcher toggle"
      "$modifier SHIFT,Return, Noctalia Launcher, exec,  noctalia-shell ipc call launcher toggle"
      "$modifier,M, Noctalia Notifications, exec, noctalia-shell ipc call notifications toggleHistory"
      "$modifier,V, Noctalia Clipboard, exec, noctalia-shell ipc call launcher clipboard"
      "$modifier ALT,P, Noctalia Settings, exec, noctalia-shell ipc call settings toggle"
      "$modifier SHIFT,comma, Noctalia Settings, exec, noctalia-shell ipc call settings toggle"
      "$modifier ALT,L, Noctalia Lock Screen, exec, noctalia-shell ipc call sessionMenu lockAndSuspend"
      "$modifier SHIFT,W, Noctalia Wallpaper, exec, noctalia-shell ipc call wallpaper toggle"
      "$modifier,X, Noctalia Power Menu, exec, noctalia-shell ipc call sessionMenu toggle"
      "$modifier,C, Noctalia Control Center, exec, noctalia-shell ipc call controlCenter toggle"
      "$modifier CTRL,R, Noctalia Screen Recorder, exec, noctalia-shell ipc call screenRecorder toggle"
    ]
    else [];
  # Rofi launcher bindings (only included when barChoice != "noctalia")
  rofiBind =
    if barChoice != "noctalia"
    then [
      # "$modifier,D, Rofi Launcher, exec, rofi-launcher"
      "$modifier,space, Rofi Launcher, exec, rofi-launcher"
    ]
    else [];
  # Rofi clipboard binding (only included when barChoice != "noctalia")
  rofiClipboardBind =
    if barChoice != "noctalia"
    then [
      "$modifier,V, Clipboard History, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
    ]
    else [];
in {
  home.packages = [
    (pkgs.writeShellScriptBin "repeat_key_toggle" ''
      NOTIFY_ID_FILE="/tmp/repeat_key_notify_id"

      # 1. If we are the internal loop instance, run the loop immediately.
      # This MUST be first so we don't accidentally pkill ourselves.
      if [ "$1" = "--internal-loop" ]; then
          while true; do
              ${pkgs.unstable.ydotool}/bin/ydotool key 17:1 17:0
              sleep 0.25
          done
      fi

      # 2. Try to kill the existing loop.
      # This runs only when user triggers the script (no args).
      if pkill -f "repeat_key_toggle --internal-loop"; then
          if [ -f "$NOTIFY_ID_FILE" ]; then
              LAST_ID=$(cat "$NOTIFY_ID_FILE")
              notify-send -r "$LAST_ID" -t 2000 "Powering down..."
              rm "$NOTIFY_ID_FILE"
          else
              notify-send "Powering down..."
          fi
          exit 0
      fi

      # 3. If nothing was killed and we aren't the loop, START the loop.
      ID=$(notify-send -p -u critical -t 0 "Melting faces..." "Press G1 to stop")
      echo "$ID" > "$NOTIFY_ID_FILE"

      "$0" --internal-loop &
      disown
    '')
  ];

  wayland.windowManager.hyprland.settings = {
    bindd =
      noctaliaBind
      ++ rofiBind
      ++ rofiClipboardBind
      ++ [
        # toggle script that hits comma every quarter second until run again
        "CTRL,F11, Melt Faces, exec, repeat_key_toggle"

        # ============= WORKSPACE OVERVIEW =============
        "$modifier CTRL,D, Toggle Dock, exec, dock"
        "$modifier, TAB, QS Overview, exec, qs ipc -c overview call overview toggle"
        # ============= TERMINALS =============
        "$modifier,Return, Terminal, exec, ${terminal}"
        # ============= APPLICATION LAUNCHERS =============
        # 34 is /
        "$modifier,code:34, Keybinds Search Tool, exec, qs-keybinds"
        # not sure why /, but got used to it on omarchy
        "$modifier SHIFT,code:34, Bitwarden, exec, bitwarden"
        "$modifier CTRL,C, Cheatsheets Viewer, exec, qs-cheatsheets"
        # "$modifier SHIFT,K, Legacy Keybinds Menu, exec, list-keybinds"
        "$modifier SHIFT,D, Discord, exec, discord"
        # "$modifier ALT,W, Web Search, exec, web-search"
        "$modifier SHIFT,W, QS Wallpaper Setter, exec, qs-wallpapers-apply"
        "$modifier SHIFT,A, Google Gemini - New Chat, exec, ${launch-desktop-file} google-gemini"
        "$modifier SHIFT,M, Google Messages, exec, ${launch-desktop-file} google-messages"
        "$modifier SHIFT,P, Google Photos, exec, ${launch-desktop-file} google-photos"
        "$modifier SHIFT,E, Gmail, exec, ${launch-desktop-file} gmail"
        "$modifier SHIFT,C, Google Calendar, exec, ${launch-desktop-file} google-calendar"
        "$modifier SHIFT,X, Plex, exec, ${launch-desktop-file} plex-web-app"
        "$modifier SHIFT,N, Neovim, exec, ${terminal} -e nvim"
        "$modifier   ALT,N, Notification Reset, exec, swaync-client -rs"
        "$modifier SHIFT,B, Web Browser, exec, ${browser}"
        "$modifier,Y, File Manager, exec, ${terminal} -e yazi"
        "$modifier,E, Emoji Picker, exec, emopicker9000"
        "$modifier,S, Screenshot, exec, screenshootin"
        # ============= SCREENSHOTS =============
        "$modifier CTRL,S, Screenshot Output, exec, hyprshot -m output -o $HOME/Pictures/ScreenShots"
        "$modifier SHIFT,S, Screenshot Window, exec, hyprshot -m window -o $HOME/Pictures/ScreenShots"
        "$modifier ALT,S, Screenshot Region, exec, hyprshot -m region -o $HOME/Pictures/ScreenShots"
        # "$modifier,O, OBS Studio, exec, obs"
        "$modifier ALT,C, Color Picker, exec, hyprpicker -a"
        "$modifier,G, GIMP, exec, gimp"
        "$modifier SHIFT,T, Dropdown Terminal, exec, pypr toggle term"
        # "$modifier,T, Thunar, exec, thunar"
        "$modifier SHIFT,F, File Manager, exec, nautilus"
        "$modifier ALT,M, Audio Control, exec, pavucontrol"
        # ============= WINDOW MANAGEMENT =============
        "$modifier,W, Kill Active Window, killactive,"
        "$modifier,P, Pseudo Tile, pseudo,"
        "$modifier,I, Toggle Split, togglesplit,"
        "$modifier,F, Full Screen, fullscreen,"
        "$modifier,T, Toggle Floating, togglefloating,"
        # "$modifier ALT,F, Float All Windows, workspaceopt, allfloat"
        "$modifier CTRL SHIFT,Q, Exit/Logout of Hyprland, exit,"
        # ============= WINDOW MOVEMENT (ARROW KEYS) =============
        "$modifier SHIFT,left, Move Left, movewindow, l"
        "$modifier SHIFT,right, Move Right, movewindow, r"
        "$modifier SHIFT,up, Move Up, movewindow, u"
        "$modifier SHIFT,down, Move Down, movewindow, d"
        # ============= WINDOW MOVEMENT (VI STYLE) =============
        "$modifier SHIFT,h, Move Left (VI), movewindow, l"
        "$modifier SHIFT,l, Move Right (VI), movewindow, r"
        "$modifier SHIFT,k, Move Up (VI), movewindow, u"
        "$modifier SHIFT,j, Move Down (VI), movewindow, d"
        # ============= WINDOW SWAPPING (ARROW KEYS) =============
        "$modifier ALT, left, Swap Left, swapwindow, l"
        "$modifier ALT, right, Swap Right, swapwindow, r"
        "$modifier ALT, up, Swap Up, swapwindow, u"
        "$modifier ALT, down, Swap Down, swapwindow, d"
        # ============= WINDOW SWAPPING (VI KEYCODES) =============
        "$modifier ALT, 43, Swap Left (VI), swapwindow, l"
        "$modifier ALT, 46, Swap Right (VI), swapwindow, r"
        "$modifier ALT, 45, Swap Up (VI), swapwindow, u"
        "$modifier ALT, 44, Swap Down (VI), swapwindow, d"
        # ============= FOCUS MOVEMENT (ARROW KEYS) =============
        "$modifier,left, Focus Left, movefocus, l"
        "$modifier,right, Focus Right, movefocus, r"
        "$modifier,up, Focus Up, movefocus, u"
        "$modifier,down, Focus Down, movefocus, d"
        # ============= FOCUS MOVEMENT (VI STYLE) =============
        "$modifier,h, Focus Left (VI), movefocus, l"
        "$modifier,l, Focus Right (VI), movefocus, r"
        "$modifier,k, Focus Up (VI), movefocus, u"
        "$modifier,j, Focus Down (VI), movefocus, d"
        # ============= WORKSPACE SWITCHING (1-10) =============
        "$modifier,1, Workspace 1, workspace, 1"
        "$modifier,2, Workspace 2, workspace, 2"
        "$modifier,3, Workspace 3, workspace, 3"
        "$modifier,4, Workspace 4, workspace, 4"
        "$modifier,5, Workspace 5, workspace, 5"
        "$modifier,6, Workspace 6, workspace, 6"
        "$modifier,7, Workspace 7, workspace, 7"
        "$modifier,8, Workspace 8, workspace, 8"
        "$modifier,9, Workspace 9, workspace, 9"
        "$modifier,0, Workspace 10, workspace, 10"
        # ============= MOVE WINDOW TO WORKSPACE (1-10) =============
        "$modifier SHIFT,grave, Move to Special, movetoworkspace, special"
        "$modifier,grave, Toggle Special, togglespecialworkspace"
        "$modifier SHIFT,1, Move to Workspace 1, movetoworkspace, 1"
        "$modifier SHIFT,2, Move to Workspace 2, movetoworkspace, 2"
        "$modifier SHIFT,3, Move to Workspace 3, movetoworkspace, 3"
        "$modifier SHIFT,4, Move to Workspace 4, movetoworkspace, 4"
        "$modifier SHIFT,5, Move to Workspace 5, movetoworkspace, 5"
        "$modifier SHIFT,6, Move to Workspace 6, movetoworkspace, 6"
        "$modifier SHIFT,7, Move to Workspace 7, movetoworkspace, 7"
        "$modifier SHIFT,8, Move to Workspace 8, movetoworkspace, 8"
        "$modifier SHIFT,9, Move to Workspace 9, movetoworkspace, 9"
        "$modifier SHIFT,0, Move to Workspace 10, movetoworkspace, 10"
        # ============= WORKSPACE NAVIGATION =============
        "$modifier CONTROL,right, Next Workspace, workspace, e+1"
        "$modifier CONTROL,left, Previous Workspace, workspace, e-1"
        "$modifier,mouse_down, Next Workspace Mouse, workspace, e+1"
        "$modifier,mouse_up, Previous Workspace Mouse, workspace, e-1"
        # ============= WINDOW CYCLING =============
        "ALT,Tab, Cycle Next Window, cyclenext"
        "ALT,Tab, Bring Active To Top, bringactivetotop"
        # ============= MEDIA & HARDWARE CONTROLS =============
        ",XF86AudioRaiseVolume, Volume Up, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        "ALT,XF86AudioRaiseVolume, Volume Up Precise, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"
        ",XF86AudioLowerVolume, Volume Down, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        "ALT,XF86AudioLowerVolume, Volume Down Precise, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
        ",XF86AudioMute, Mute Toggle, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioPlay, Play Pause, exec, playerctl play-pause"
        ",XF86AudioPause, Play Pause, exec, playerctl play-pause"
        ",XF86AudioNext, Next Track, exec, playerctl next"
        ",XF86AudioPrev, Previous Track, exec, playerctl previous"
        ",XF86MonBrightnessDown, Brightness Down, exec, brightnessctl set 5%-"
        ",XF86MonBrightnessUp, Brightness Up, exec, brightnessctl set +5%"
      ];

    bindm = [
      "$modifier, mouse:272, movewindow"
      "$modifier, mouse:273, resizewindow"
    ];
  };
}

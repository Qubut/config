{ userSettings, ... }:
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      # ===== SCREENSHOTS =====
      "SUPER, PRINT, exec, hyprshot -m window"
      ", PRINT, exec, hyprshot -m output"
      "SUPERSHIFT, PRINT, exec, hyprshot -m region"
      "ALT, PRINT, exec, XDG_CURRENT_DESKTOP=sway flameshot"

      # ===== APPLICATIONS =====
      "SUPER,I,exec,networkmanager_dmenu"
      "SUPER,T,exec,${userSettings.term}"
      "SUPER,grave,exec,${userSettings.browser}"
      "SUPER,P,exec, kitty --class scratch_term -e ipdf ~"
      "SUPER,O,exec, obsidian"
      "SUPERSHIFT,P,exec,hyprprofile-dmenu"
      "SUPER,F1,exec,fuzzel"
      "SUPER,X,exec,fnottctl dismiss"
      "SUPERSHIFT,X,exec,fnottctl dismiss all"

      # ===== SCRATCHPADS =====
      "SUPER,Z,exec,if hyprctl clients | grep -q scratch_term; then echo \"scratch_term respawn not needed\"; else hyprctl dispatch exec \"[workspace special:scratch_term silent] alacritty --class scratch_term\"; fi"
      "SUPER,Z,togglespecialworkspace,scratch_term"
      "SUPER,F,exec,if hyprctl clients | grep -q scratch_ranger; then echo \"scratch_ranger respawn not needed\"; else kitty --class scratch_ranger -e ranger\"; fi"
      "SUPER,F,togglespecialworkspace,scratch_ranger"
      "SUPER,V,exec,if hyprctl clients | grep -q scratch_thunar; then echo \"scratch_thunar respawn not needed\"; else hyprctl dispatch exec \"[workspace special:scratch_thunar silent] thunar --class scratch_thunar\"; fi"
      "SUPER,V,togglespecialworkspace,scratch_thunar"
      "SUPERSHIFT,B,exec,if hyprctl clients | grep -q scratch_btm; then echo \"scratch_btm respawn not needed\"; else alacritty --class scratch_btm -e btm\"; fi"
      "SUPERSHIFT,B,togglespecialworkspace,scratch_btm"
      "SUPER,code:172,exec,togglespecialworkspace,scratch_pavucontrol"
      "SUPER,code:172,exec,if hyprctl clients | grep -q org.pulseaudio.pavucontrol; then echo \"scratch_ranger respawn not needed\"; else pavucontrol; fi"

      # ===== GROUP MANAGEMENT =====
      "SUPER,slash,togglegroup"
      "SUPER,bracketright,changegroupactive,f"
      "SUPER,bracketleft,changegroupactive,b"
      "SUPER,comma,lockactivegroup,toggle"

      # ===== WINDOW MANAGEMENT =====
      "SUPER,E,togglefloating"
      "SUPER,SPACE,fullscreen,1"
      "SUPERSHIFT,F,fullscreen,0"
      "SUPER,Y,workspaceopt,allfloat"
      "ALT,TAB,cyclenext"
      "ALT,TAB,bringactivetotop"
      "ALTSHIFT,TAB,cyclenext,prev"
      "ALTSHIFT,TAB,bringactivetotop"
      "SUPER,TAB,hyprexpo:expo, toggle"
      "SUPER,U,focusurgentorlast"
      "SUPER,Q,killactive"

      # ===== CURSOR ZOOM =====
      "SUPER,equal, exec, hyprctl keyword cursor:zoom_factor \"$(hyprctl getoption cursor:zoom_factor | grep float | awk '{print $2 + 0.5}')\""
      "SUPER,minus, exec, hyprctl keyword cursor:zoom_factor \"$(hyprctl getoption cursor:zoom_factor | grep float | awk '{print $2 - 0.5}')\""

      # ===== CLIPBOARD =====
      "SUPER,V,exec,wl-copy $(wl-paste | tr \\n)"

      # ===== SYSTEM CONTROLS =====
      "CTRLALT,Delete,exec,hyprctl kill"
      "SUPERSHIFT,K,exec,hyprctl kill"
      "SUPERSHIFT,Q,exit"
      "SUPERSHIFT,S,exec,systemctl suspend"
      ",switch:on:Lid Switch,exec,loginctl lock-session"
      "SUPERCTRL,L,exec,loginctl lock-session"

      # ===== MEDIA CONTROLS =====
      ",code:122,exec,swayosd-client --output-volume lower"
      ",code:123,exec,swayosd-client --output-volume raise"
      ",code:121,exec,swayosd-client --output-volume mute-toggle"
      ",code:256,exec,swayosd-client --output-volume mute-toggle"
      "SHIFT,code:122,exec,swayosd-client --output-volume lower"
      "SHIFT,code:123,exec,swayosd-client --output-volume raise"

      ",code:232,exec,swayosd-client --brightness lower"
      ",code:233,exec,swayosd-client --brightness raise"

      ",code:237,exec,brightnessctl --device='asus::kbd_backlight' set 1-"
      ",code:238,exec,brightnessctl --device='asus::kbd_backlight' set +1"

      ",code:255,exec,airplane-mode"

      # Workspace navigation with hyprnome
      "SUPERCTRL,right,exec,hyprnome"
      "SUPERCTRL,left,exec,hyprnome --previous"
      "SUPERSHIFT,right,exec,hyprnome --move"
      "SUPERSHIFT,left,exec,hyprnome --previous --move"

      # ===== WORKSPACE NAVIGATION =====
      "SUPER,1,focusworkspaceoncurrentmonitor,1"
      "SUPER,2,focusworkspaceoncurrentmonitor,2"
      "SUPER,3,focusworkspaceoncurrentmonitor,3"
      "SUPER,4,focusworkspaceoncurrentmonitor,4"
      "SUPER,5,focusworkspaceoncurrentmonitor,5"
      "SUPER,6,focusworkspaceoncurrentmonitor,6"
      "SUPER,7,focusworkspaceoncurrentmonitor,7"
      "SUPER,8,focusworkspaceoncurrentmonitor,8"
      "SUPER,9,focusworkspaceoncurrentmonitor,9"

      # Move windows to workspaces (with follow)
      "SUPERSHIFT,1,movetoworkspace,1,follow"
      "SUPERSHIFT,2,movetoworkspace,2,follow"
      "SUPERSHIFT,3,movetoworkspace,3,follow"
      "SUPERSHIFT,4,movetoworkspace,4,follow"
      "SUPERSHIFT,5,movetoworkspace,5,follow"
      "SUPERSHIFT,6,movetoworkspace,6,follow"
      "SUPERSHIFT,7,movetoworkspace,7,follow"
      "SUPERSHIFT,8,movetoworkspace,8,follow"
      "SUPERSHIFT,9,movetoworkspace,9,follow"

      # Move windows to workspaces without follow
      "SUPERALT,1,movetoworkspace,1"
      "SUPERALT,2,movetoworkspace,2"
      "SUPERALT,3,movetoworkspace,3"
      "SUPERALT,4,movetoworkspace,4"
      "SUPERALT,5,movetoworkspace,5"
      "SUPERALT,6,movetoworkspace,6"
      "SUPERALT,7,movetoworkspace,7"
      "SUPERALT,8,movetoworkspace,8"
      "SUPERALT,9,movetoworkspace,9"
    ];

    bindm = [
      "SUPER,mouse:272,movewindow"
      "SUPER,mouse:273,resizewindow"
    ];
  };

}

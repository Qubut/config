{ config, userSettings, ... }:
let
  cursorSize = builtins.toString userSettings.cursorSize;
in
{
  wayland.windowManager.hyprland.settings = {
    env = [
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "WLR_DRM_DEVICES,/dev/dri/card2:/dev/dri/card1"
      "GDK_BACKEND,wayland,x11,*"
      "QT_QPA_PLATFORM,wayland;xcb"
      "QT_QPA_PLATFORMTHEME,qt6ct"
      "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      "CLUTTER_BACKEND,wayland"
      "XCURSOR_SIZE, ${cursorSize}"
      "LIBVA_DRIVER_NAME,nvidia"
      "GLX_VENDOR_LIBRARY_NAME,nvidia"
      "ELECTRON_OZONE_PLATFORM_HINT,auto"
      # HDR support for applications
      "ENABLE_HDR_WSI,1"
      "DXVK_HDR,1"
    ];
    exec-once = [
      "hyprpm reload -n"
      "dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_SESSION_DESKTOP=Hyprland XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland"
      "hyprctl setcursor ${config.gtk.cursorTheme.name} ${cursorSize}"
      "sleep 5 && libinput-gestures"
      "hyprpaper"
      "nm-applet"
      "nm-applet"
      "blueman-applet"
      "waybar"
    ];
  };
}

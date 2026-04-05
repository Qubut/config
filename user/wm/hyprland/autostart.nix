{ config, userSettings, systemSettings, ... }:
let
  cursorSize = builtins.toString userSettings.cursorSize;
  isNvidia = systemSettings.gpuType == "nvidia";
  isAmd = systemSettings.gpuType == "amd";

  # Base environment variables (all GPUs)
  baseEnvVars = [
    "XDG_CURRENT_DESKTOP,Hyprland"
    "XDG_SESSION_DESKTOP,Hyprland"
    "XDG_SESSION_TYPE,wayland"
    "GDK_BACKEND,wayland,x11,*"
    "QT_QPA_PLATFORM,wayland;xcb"
    "QT_QPA_PLATFORMTHEME,qt6ct"
    "QT_AUTO_SCREEN_SCALE_FACTOR,1"
    "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
    "CLUTTER_BACKEND,wayland"
    "XCURSOR_THEME,${config.gtk.cursorTheme.name}"
    "XCURSOR_SIZE,${cursorSize}"
    "ELECTRON_OZONE_PLATFORM_HINT,auto"
    "NIXOS_OZONE_WL,1"
    "MOZ_ENABLE_WAYLAND,1"
  ];

  # NVIDIA-specific environment variables
  nvidiaEnvVars = [
    "LIBVA_DRIVER_NAME,nvidia"
    "GLX_VENDOR_LIBRARY_NAME,nvidia"
    "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    "NVD_BACKEND,direct"
    "ENABLE_HDR_WSI,1"
    "DXVK_HDR,1"
  ];

  # AMD-specific environment variables
  amdEnvVars = [
    "LIBVA_DRIVER_NAME,radeonsi"
    "AMD_VULKAN_ICD,RADV"
  ];

  # Intel-specific environment variables
  intelEnvVars = [
    "LIBVA_DRIVER_NAME,iHD"
  ];

  # Select GPU-specific vars based on gpuType
  gpuEnvVars =
    if isNvidia then nvidiaEnvVars
    else if isAmd then amdEnvVars
    else intelEnvVars;
in
{
  wayland.windowManager.hyprland.settings = {
    env = baseEnvVars ++ gpuEnvVars;
    exec-once = [
      # hyprpm is not needed when using Nix-managed plugins (via wayland.windowManager.hyprland.plugins)
      # "hyprpm reload -n"
      "dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_SESSION_DESKTOP=Hyprland XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland"
      "hyprctl setcursor ${config.gtk.cursorTheme.name} ${cursorSize}"
      "sleep 5 && libinput-gestures"
      "hyprpaper"
      "nm-applet"
      "blueman-applet"
      "waybar"
      # scratchpad-handler is managed by systemd user service
    ];
  };
}

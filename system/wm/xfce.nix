{ config, pkgs, callPackage, userSettings, ... }: {
  environment.systemPackages = (with pkgs.xfce; [
    xfce4-pulseaudio-plugin
    xfce4-xkb-plugin
    thunar-archive-plugin
    xfce4-whiskermenu-plugin

  ])
    # Broken!
    # ++ (with pkgs; [xmonad_log_applet_xfce])
  ;
  services.xserver = {
    enable = (userSettings.wmType == "x11");
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        enableScreensaver = true;
      };
    };
  };
  # services.displayManager.defaultSession = "xfce";
}

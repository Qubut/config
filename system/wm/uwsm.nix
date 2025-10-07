{ config, ... }:
{
  programs.uwsm = {
    enable = true;

    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland with proper systemd integration";
        binPath = "${config.wayland.windowManager.hyprland.package}/bin/Hyprland";
      };
    };
  };
}

{ lib, pkgs, ... }:

{
  services.dbus.enable = true;
  services.tumbler.enable = true; # Thumbnail support for images
  services.openssh.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.acpid = {
    enable = true;
    logEvents = true;
    handlers = {
      brightnessUp = {
        event = "video/brightnessup.*";
        action = "${pkgs.brightnessctl}/bin/brightnessctl --device=intel_backlight set +5% || true";
      };
      brightnessDown = {
        event = "video/brightnessdown.*";
        action = "${pkgs.brightnessctl}/bin/brightnessctl --device=intel_backlight set 5%- || true";
      };
      brightnessCycle = {
        event = "video/brightnesscycle.*";
        action = "${pkgs.brightnessctl}/bin/brightnessctl --device=intel_backlight set +5% || true";
      };
    };
  };
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    services."systemd-suspend" = {
      serviceConfig = {
        Environment=''"SYSTEMD_SLEEP_FREEZE_USER_SESSIONS=false"'';
      };
    };
  };

}

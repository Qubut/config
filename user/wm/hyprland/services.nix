{ pkgs, pkgs-unstable, config, ... }:


{
  services = {
    udiskie = {
      enable = true;
      tray = "always";
    };
    swayosd = {
      enable = true;
      topMargin = 0.5;
    };
    hyprsunset = {
      enable = true;
      package = pkgs-unstable.hyprsunset;
      settings = {
        "max-gamma" = 100;
        profile = [
          {
            time = "06:00";
            temperature = 5000;
            gamma = 1.0;
          }
          {
            time = "19:00";
            temperature = 3400; # Warmer evening
            gamma = 1.0;
          }
          {
            time = "21:00";
            temperature = 2900; # Even warmer for night
            gamma = 1.0;
          }
        ];
      };
    };

    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # Prevent duplicate locks
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          inhibit_sleep = 2; # Auto mode for sleep inhibition
        };

        listener = [
          {
            timeout = 150;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = 150;
            on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
            on-resume = "brightnessctl -rd rgb:kbd_backlight";
          }
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 330;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };

  };
}

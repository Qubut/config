{ config, userSettings, ... }:

let
  colors = config.lib.stylix.colors;
  base00 = "rgb(${colors.base00-rgb-r}, ${colors.base00-rgb-g}, ${colors.base00-rgb-b})";
  base07 = "rgb(${colors.base07-rgb-r}, ${colors.base07-rgb-g}, ${colors.base07-rgb-b})";
  base08 = "rgb(${colors.base08-rgb-r}, ${colors.base08-rgb-g}, ${colors.base08-rgb-b})";
  base0A = "rgb(${colors.base0A-rgb-r}, ${colors.base0A-rgb-g}, ${colors.base0A-rgb-b})";

  # Common positions for centering
  centerPos = "0";
  centerHalign = "center";
  centerValign = "center";
in
{
  programs.hyprlock = {
    enable = true;
    sourceFirst = true; # Put source entries at the top of the config for priority

    settings = {
      background = [
        {
          monitor = "";
          path = "screenshot";

          # Blur options (from Hyprland vars); disable passes if GPU is weak
          blur_passes = 4; # Set to 0 for no blur on low-end hardware
          blur_size = 5;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      image = [
        {
          monitor = "";
          path = "/home/emmet/.dotfiles/user/wm/hyprland/nix-dark.png";
          size = 150; # Lesser side if not 1:1 ratio
          rounding = -1; # Negative for circle
          border_size = 0;
          rotate = 0; # Degrees, counter-clockwise

          position = "${centerPos}, 200";
          halign = centerHalign;
          valign = centerValign;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "200, 50";
          outline_thickness = 3;
          dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = false;
          dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
          outer_color = base07;
          inner_color = base00;
          font_color = base07;
          fade_on_empty = true;
          fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered
          placeholder_text = "<i>Input Password...</i>"; # Text when empty
          hide_input = false;
          rounding = -1; # -1 for complete rounding (circle/oval)
          check_color = base0A;
          fail_color = base08;
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # Can be empty
          fail_transition = 300; # ms between normal and fail color
          capslock_color = -1;
          numlock_color = -1;
          bothlock_color = -1; # -1 means don't change outer color
          invert_numlock = false;
          swap_font_color = false;

          position = "${centerPos}, -20";
          halign = centerHalign;
          valign = centerValign;
        }
      ];

      label = [
        {
          monitor = "";
          text = "Hello, ${userSettings.name}";
          color = base07;
          font_size = 25;
          font_family = userSettings.font;

          rotate = 0; # Degrees, counter-clockwise

          position = "${centerPos}, 160";
          halign = centerHalign;
          valign = centerValign;
        }
        {
          monitor = "";
          text = "$TIME";
          color = base07;
          font_size = 20;
          font_family = "Intel One Mono";
          rotate = 0; # Degrees, counter-clockwise

          position = "${centerPos}, 80";
          halign = centerHalign;
          valign = centerValign;
        }
        # Add date label (remove if not wanted)
        {
          monitor = "";
          text = "cmd[update:1000] date +'%A, %B %d'"; # Dynamic update every 1s
          color = base07;
          font_size = 18;
          font_family = "Intel One Mono";
          rotate = 0;

          position = "${centerPos}, 50";
          halign = centerHalign;
          valign = centerValign;
        }
      ];
    };
  };
  stylix.targets.hyprlock.enable = true;
}

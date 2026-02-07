{ pkgs-unstable, config, inputs, ... }:
let
  toRgb = color: "rgb(${color})";
  toRgba = color: "rgba(${color}55)";
  baseColors = config.lib.stylix.colors;
  hyprtrailsConfig = {
    color = toRgba baseColors.base08;
  };

  hyprexpoConfig = {
    columns = 3;
    gap_size = 5;
    bg_col = toRgb baseColors.base00;
    workspace_method = "first 1";
    enable_gesture = true;
  };

  touchGesturesConfig = {
    sensitivity = 4.0;
    long_press_delay = 260;
  };
  hy3Config = {
    no_gaps_when_only = 0;
    node_collapse_policy = 2;
    group_inset = 10;
    tab_first_window = false;

    tabs = {
      height = 22;
      padding = 6;
      from_top = false;
      radius = 6;
      border_width = 2;
      render_text = true;
      text_center = true;
      text_font = "Sans";
      text_height = 8;
      text_padding = 3;
      "col.active" = "0xff${baseColors.base0D}40";
      "col.active.border" = "0xff${baseColors.base0D}ee";
      "col.active.text" = "0xffffffff";
      "col.focused" = "0xff${baseColors.base0D}40";
      "col.focused.border" = "0xff${baseColors.base0D}ee";
      "col.focused.text" = "0xffffffff";
      "col.inactive" = "0xff${baseColors.base02}20";
      "col.inactive.border" = "0xff${baseColors.base02}aa";
      "col.inactive.text" = "0xffffffff";
      "col.urgent" = "0xff${baseColors.base08}40";
      "col.urgent.border" = "0xff${baseColors.base08}ee";
      "col.urgent.text" = "0xffffffff";
      "col.locked" = "0xff${baseColors.base0A}40";
      "col.locked.border" = "0xff${baseColors.base0A}ee";
      "col.locked.text" = "0xffffffff";
      blur = true;
      opacity = 1.0;
    };

    autotile = {
      enable = false;
      ephemeral_groups = true;
      trigger_width = 0;
      trigger_height = 0;
      workspaces = "1,2,3,4,5,6,7,8,9";
    };
  };
in
{
  wayland.windowManager.hyprland = {
    plugins = with pkgs-unstable; [
      inputs.hyprland-plugins.packages.${pkgs-unstable.system}.hyprtrails
      inputs.hyprland-plugins.packages.${pkgs-unstable.system}.hyprexpo
    ];

    settings.plugin = {
      hyprtrails = hyprtrailsConfig;
      hyprexpo = hyprexpoConfig;
      touch_gestures = touchGesturesConfig;
    };
  };
}

{ inputs
, config
, lib
, pkgs
, pkgs-unstable
, userSettings
, systemSettings
, ...
}:
let
  systemPackages = inputs.hyprland.packages.${pkgs.system};
  baseColors = config.lib.stylix.colors;
  toColor = color: "0xff${color}";

  bezierSettings = [
    "wind, 0.05, 0.9, 0.1, 1.05"
    "winIn, 0.1, 1.1, 0.1, 1.0"
    "winOut, 0.3, -0.3, 0, 1"
    "liner, 1, 1, 1, 1"
    "linear, 0.0, 0.0, 1.0, 1.0"
  ];

  animationSettings = [
    "windowsIn, 1, 6, winIn, popin"
    "windowsOut, 1, 5, winOut, popin"
    "windowsMove, 1, 5, wind, slide"
    "border, 1, 10, default"
    "borderangle, 1, 100, linear, loop"
    "fade, 1, 10, default"
    "workspaces, 1, 5, wind"
    "windows, 1, 6, wind, slide"
    "specialWorkspace, 1, 6, default, slidefadevert -50%"
  ];

  activeBorderColors = lib.concatStringsSep " " (
    map toColor [
      baseColors.base08
      baseColors.base09
      baseColors.base0A
      baseColors.base0B
      baseColors.base0C
      baseColors.base0D
      baseColors.base0E
      baseColors.base0F
    ]
  );
in
{
  imports = [
    ./autostart.nix
    ./deps.nix
    ./hyprlock.nix
    ./key-bindings.nix
    ./plugins.nix
    ./services.nix
    ./window-rules.nix
    ../utils/gtklock.nix
    ../utils/fnott.nix
    ../utils/fuzzel.nix
    ../utils/waybar.nix
    ../utils/redshift.nix
  ];

  gtk.cursorTheme = {
    package = pkgs.quintom-cursor-theme;
    name = if (config.stylix.polarity == "light") then "Quintom_Ink" else "Quintom_Snow";
    size = userSettings.cursorSize;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = systemPackages.hyprland;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    systemd.enable = true;

    settings = {
      bezier = bezierSettings;
      animations = {
        enabled = true;
        animation = animationSettings;
      };

      # XWayland settings
      xwayland = {
        enabled = true;
        use_nearest_neighbor = true;
        force_zero_scaling = true;
        create_abstract_socket = false;
      };

      # OpenGL settings
      opengl = {
        nvidia_anti_flicker = true;
      };

      # Render settings
      render = {
        direct_scanout = 0;
        expand_undersized_textures = true;
        xp_mode = false;
        ctm_animation = 2;
        cm_fs_passthrough = 2;
        cm_enabled = true;
        send_content_type = true;
        cm_auto_hdr = 1;
        new_render_scheduling = false;
      };

      # Cursor settings (enhanced)
      cursor = {
        invisible = false;
        sync_gsettings_theme = true;
        no_hardware_cursors = 2;
        no_break_fs_vrr = 2;
        min_refresh_rate = 24;
        hotspot_padding = 1;
        inactive_timeout = 30;
        no_warps = false;
        persistent_warps = false;
        warp_on_change_workspace = 0;
        warp_on_toggle_special = 0;
        default_monitor = "";
        zoom_factor = 1.0;
        zoom_rigid = false;
        enable_hyprcursor = true;
        hide_on_key_press = false;
        hide_on_touch = true;
        use_cpu_buffer = 2;
        warp_back_after_non_mouse_input = false;
      };

      # Ecosystem settings
      ecosystem = {
        no_update_news = false;
        no_donation_nag = false;
        enforce_permissions = false;
      };

      # Experimental settings
      experimental = {
        xx_color_management_v4 = false;
      };

      general = {
        layout = "master";
        border_size = 2;
        "col.active_border" = "${activeBorderColors} 270deg";
        "col.inactive_border" = toColor baseColors.base02;
        resize_on_border = true;
        gaps_in = 7;
        gaps_out = 7;
        allow_tearing = false;
      };

      group = {
        # Group border colors
        "col.border_active" = "${activeBorderColors} 270deg";
        "col.border_inactive" = "0xff${baseColors.base02}aa";
        "col.border_locked_active" = "0xff${baseColors.base0A}ee";
        "col.border_locked_inactive" = "0xff${baseColors.base02}aa";

        # Group settings
        auto_group = true;
        insert_after_current = true;
        focus_removed_window = true;
        drag_into_group = 1;
        merge_groups_on_drag = true;
        merge_groups_on_groupbar = true;
        merge_floated_into_tiled_on_groupbar = false;
        group_on_movetoworkspace = false;
        groupbar = {
          "col.active" = "0xff${baseColors.base0D}40";
          "col.inactive" = "0xff${baseColors.base02}20";
          "col.locked_active" = "0xff${baseColors.base0D}40";
          "col.locked_inactive" = "0xff${baseColors.base0A}20";

          "text_color" = "0xffffffff";
          "text_color_inactive" = "0xffffffff";
          "text_color_locked_active" = "0xffffffff";
          "text_color_locked_inactive" = "0xffffffff";

          enabled = true;
          font_size = 14;
          font_weight_active = "normal";
          font_weight_inactive = "normal";
          gradients = true;
          height = 14;
          indicator_gap = 0;
          indicator_height = 3;
          stacked = false;
          priority = 3;
          render_titles = true;
          text_offset = 0;
          scrolling = true;
          rounding = 1;
          rounding_power = 2.0;
          gradient_rounding = 2;
          gradient_rounding_power = 2.0;
          round_only_edges = true;
          gradient_round_only_edges = true;
          gaps_in = 2;
          gaps_out = 2;
          keep_upper_gap = true;
        };
      };

      monitor = [
        "DP-4,3840x2160@119.88,auto,1.06666667"
      ];

      layerrule = [
        "blur,waybar"
        "xray,waybar"
        "blur,launcher"
        "blur,gtk-layer-shell"
        "xray,gtk-layer-shell"
        "blur,~nwggrid"
        "xray 1,~nwggrid"
        "animation fade,~nwggrid"
      ];

      blurls = [
        "waybar"
        "launcher"
        "gtk-layer-shell"
        "~nwggrid"
      ];

      binds = {
        movefocus_cycles_fullscreen = false;
      };

      input = {
        kb_layout = "eu, ara, ru, tr";
        kb_options = "grp:rctrl_rshift_toggle";
        kb_variant = ",buckwalter,phonetic,";
        repeat_delay = 350;
        repeat_rate = 50;
        accel_profile = "adaptive";
        follow_mouse = 2;
        float_switch_override_focus = 0;
      };

      misc = {
        disable_hyprland_logo = true;
        mouse_move_enables_dpms = true;
        enable_swallow = true;
        swallow_regex = "(scratch_term)|(Alacritty)|(kitty)";
        font_family = userSettings.font;
      };

      decoration = {
        rounding = 8;
        dim_special = 0.0;
        blur = {
          enabled = true;
          new_optimizations = true;
          size = 5;
          passes = 2;
          ignore_opacity = true;
          contrast = 1.17;
          brightness = if (config.stylix.polarity == "dark") then "0.8" else "1.25";
          xray = true;
          special = true;
          popups = true;
        };
      };
    };
  };
}

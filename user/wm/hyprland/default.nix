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
  systemPackages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
  baseColors = config.lib.stylix.colors;
  toColor = color: "0xff${color}";

  # GPU detection for conditional settings
  isNvidia = systemSettings.gpuType == "nvidia";
  isAmd = systemSettings.gpuType == "amd";

  bezierSettings = [
    "wind, 0.05, 0.9, 0.1, 1.05"
    "winIn, 0.1, 1.1, 0.1, 1.0"
    "winOut, 0.3, -0.3, 0, 1"
    "liner, 1, 1, 1, 1"
    "linear, 0.0, 0.0, 1.0, 1.0"
    "easeOutExpo, 0.16, 1, 0.3, 1"
    "easeInOutQuart, 0.76, 0, 0.24, 1"
  ];

  animationSettings = [
    "windowsIn, 1, 6, winIn, popin"
    "windowsOut, 1, 5, winOut, popin"
    "windowsMove, 1, 5, wind, slide"
    "border, 1, 10, default"
    "borderangle, 1, 100, linear, once"
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
    # Disable Home Manager systemd integration when using UWSM (withUWSM = true in system config)
    systemd.enable = false;

    settings = {
      bezier = bezierSettings;
      animations = {
        enabled = true;
        workspace_wraparound = true;
        animation = animationSettings;
      };

      # XWayland settings
      xwayland = {
        enabled = true;
        use_nearest_neighbor = true;
        force_zero_scaling = true;
        create_abstract_socket = false;
      };

      # OpenGL settings (GPU-conditional)
      opengl = lib.mkIf isNvidia {
        nvidia_anti_flicker = true;
      };

      # Render settings (GPU-conditional)
      render = {
        direct_scanout = if isNvidia then 0 else 1;
        expand_undersized_textures = true;
        xp_mode = false;
        ctm_animation = 2;
        cm_fs_passthrough = 2;
        cm_enabled = true;
        send_content_type = true;
        cm_auto_hdr = 1;
        new_render_scheduling = false;
        # explicit_sync and explicit_sync_kms removed in Hyprland 0.54
      };

      # Cursor settings (GPU-conditional)
      cursor = {
        invisible = false;
        sync_gsettings_theme = true;
        no_hardware_cursors = if isNvidia then 2 else 0;
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
        use_cpu_buffer = if isNvidia then 2 else 0;
        warp_back_after_non_mouse_input = false;
      };

      # Ecosystem settings
      ecosystem = {
        no_update_news = false;
        no_donation_nag = false;
        enforce_permissions = false;
      };

      # experimental:xx_color_management_v4 removed in Hyprland 0.54

      general = {
        layout = "master";
        border_size = 2;
        "col.active_border" = "${activeBorderColors} 270deg";
        "col.inactive_border" = toColor baseColors.base02;
        resize_on_border = true;
        gaps_in = 7;
        gaps_out = 7;
        allow_tearing = false;
        snap = {
          enabled = true;
          window_gap = 10;
          monitor_gap = 10;
          border_overlap = false;
        };
      };

      group = {
        "col.border_active" = "${activeBorderColors} 270deg";
        "col.border_inactive" = "0xff${baseColors.base02}aa";
        "col.border_locked_active" = "0xff${baseColors.base0A}ee";
        "col.border_locked_inactive" = "0xff${baseColors.base02}aa";

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
        "blur on, match:namespace waybar"
        "xray on, match:namespace waybar"
        "blur on, match:namespace launcher"
        "blur on, match:namespace gtk-layer-shell"
        "xray on, match:namespace gtk-layer-shell"
        "blur on, match:namespace ~nwggrid"
        "xray on, match:namespace ~nwggrid"
        "animation fade, match:namespace ~nwggrid"
      ];

      # blurls is deprecated in Hyprland 0.54, use layerrule instead

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
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
          drag_lock = true;
          disable_while_typing = true;
          scroll_factor = 1.0;
        };
      };

      misc = {
        disable_hyprland_logo = true;
        mouse_move_enables_dpms = true;
        enable_swallow = true;
        swallow_regex = "(scratch_term)|(Alacritty)|(kitty)";
        font_family = userSettings.font;
        vfr = true;
        vrr = 1;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
        disable_watchdog_warning = true;  # Suppress "started without start-hyprland" warning
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
        shadow = {
          enabled = true;
          range = 8;
          render_power = 2;
          color = "0x66000000";
          color_inactive = "0x33000000";
          offset = "0 2";
        };
      };

      # Gestures - workspace_swipe* options removed in Hyprland 0.54
      # Use the new gesture syntax instead
      gestures = {
        workspace_swipe_distance = 300;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_min_speed_to_force = 30;
        workspace_swipe_create_new = true;
        workspace_swipe_invert = true;
      };

      # New gesture syntax for workspace swiping (replaces workspace_swipe and workspace_swipe_fingers)
      gesture = [
        "3, horizontal, workspace"
      ];

      debug = {
        disable_logs = false;
        enable_stdout_logs = false;
      };

      # Smart gaps - remove gaps when only one tiled window
      # Per-workspace layouts (0.54 feature)
      workspace = [
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
        "1, layout:master"
        "2, layout:master"
        "3, layout:dwindle"
        "4, layout:dwindle"
        "5, layout:master"
        "6, layout:master"
        "7, layout:master"
        "8, layout:master"
        "9, layout:monocle"
        # Special workspaces (scratchpads) with auto-spawn
        "special:scratch_term, on-created-empty:alacritty --class scratch_term"
        "special:scratch_ranger, on-created-empty:kitty --class scratch_ranger -e ranger"
        "special:scratch_thunar, on-created-empty:thunar"
        "special:scratch_btm, on-created-empty:alacritty --class scratch_btm -e btm"
        "special:scratch_pavucontrol, on-created-empty:pavucontrol"
      ];
    };
  };
}

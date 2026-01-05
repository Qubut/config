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
  toRgba = color: "rgba(${color}55)";
  toRgb = color: "rgb(${color})";

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

  # Plugin settings
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

  cursorSize = 30;
  cursorSizeStr = "30";
  scratchpadsize = "size 80% 85%";
  dropdownsize = "size 100% 35%";
  scratch_term = "class:^(scratch_term)$";
  scratch_ranger = "class:^(scratch_ranger)$";
  scratch_thunar = "class:^(scratch_thunar)$";
  scratch_btm = "class:^(scratch_btm)$";
  savetodisk = "title:^(Save to Disk)$";
  pavucontrol = "class:^(org.pulseaudio.pavucontrol)$";
  miniframe = "title:\*Minibuf.*";

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
  imports = [
    ./services.nix
    ./deps.nix
    ./hyprlock.nix
    ../utils/gtklock.nix
    ../utils/fnott.nix
    ../utils/fuzzel.nix
    ../utils/waybar.nix
    ../utils/redshift.nix
  ];

  gtk.cursorTheme = {
    package = pkgs.quintom-cursor-theme;
    name = if (config.stylix.polarity == "light") then "Quintom_Ink" else "Quintom_Snow";
    size = cursorSize;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = systemPackages.hyprland;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    systemd.enable = true;

    plugins = with pkgs-unstable; [
      inputs.hyprland-plugins.packages.${pkgs-unstable.system}.hyprtrails
      inputs.hyprland-plugins.packages.${pkgs-unstable.system}.hyprexpo
    ];

    settings = {
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
        "XCURSOR_SIZE, ${cursorSizeStr}"
        "LIBVA_DRIVER_NAME,nvidia"
        "GLX_VENDOR_LIBRARY_NAME,nvidia"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        # HDR support for applications
        "ENABLE_HDR_WSI,1"
        "DXVK_HDR,1"
      ];

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

      plugin = {
        hyprtrails = hyprtrailsConfig;
        hyprexpo = hyprexpoConfig;
        touch_gestures = touchGesturesConfig;
      };

      monitor = [
        "DP-4,3840x2160@119.88,auto,1.06666667"
      ];

      exec-once = [
        "hyprpm reload -n"
        "dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_SESSION_DESKTOP=Hyprland XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland"
        "hyprctl setcursor ${config.gtk.cursorTheme.name} ${cursorSizeStr}"
        "sleep 5 && libinput-gestures"
        "hyprpaper"
        "nm-applet"
        "nm-applet"
        "blueman-applet"
        "waybar"
      ];

      windowrulev2 = [
        # Scratchpad rules
        "float,${scratch_term}"
        "${dropdownsize},${scratch_term}"
        "move 0% 0%,${scratch_term}"
        "animation slidevert,${scratch_term}"

        "float,${scratch_ranger}"
        "${scratchpadsize},${scratch_ranger}"
        "center,${scratch_ranger}"

        "float,${scratch_thunar}"
        "${scratchpadsize},${scratch_thunar}"
        "center,${scratch_thunar}"

        "float,${scratch_btm}"
        "${scratchpadsize},${scratch_btm}"
        "center,${scratch_btm}"

        "float,${savetodisk}"
        "size 70% 75%,${savetodisk}"
        "center,${savetodisk}"

        "float,${pavucontrol}"
        "size 86% 40%,${pavucontrol}"
        "move 50% 6%,${pavucontrol}"
        "workspace special silent,${pavucontrol}"
        "opacity 0.80,${pavucontrol}"

        "float,${miniframe}"
        "size 64% 50%,${miniframe}"
        "move 18% 25%,${miniframe}"
        "animation popin 1 20,${miniframe}"
        # xwayland window rules
        "opacity 0.0 override, class:^(xwaylandvideobridge)$"
        "noanim, class:^(xwaylandvideobridge)$"
        "noinitialfocus, class:^(xwaylandvideobridge)$"
        "maxsize 1 1, class:^(xwaylandvideobridge)$"
        "noblur, class:^(xwaylandvideobridge)$"
        "nofocus, class:^(xwaylandvideobridge)$"
        # Application-specific rules
        "float,class:^(pokefinder)$"
        "opacity 0.80,title:orui"
        "opacity 1.0,class:^(org.qutebrowser.qutebrowser),fullscreen:1"
        "opacity 0.85,class:^(element)$"
        "opacity 0.85,class:^(lollypop)$"
        "opacity 1.0,class:^(brave-browser),fullscreen:1"
        "opacity 1.0,class:^(librewolf),fullscreen:1"
        "opacity 0.85,title:^(my local dashboard awesome homepage - qutebrowser)$"
        "opacity 0.85,title:\[.*\] - my local dashboard awesome homepage"
        "opacity 0.85,class:^(org.keepassxc.keepassxc)$"
        "opacity 0.85,class:^(org.gnome.nautilus)$"

        # Group rules
        "group, title:codium"
        "group, class:firefox"
        "group, class:codium"

        # Flameshot rules
        "float,class:flameshot"
        "monitor 0,class:flameshot"
        "move 0 0,class:flameshot"
        "noanim,class:flameshot"
        "noborder,class:flameshot"
        "rounding 0,class:flameshot"

        # Comprehensive float rules
        "float,title:^(Application Finder)$"
        "float,title:^(Whisker Menu)$"
        "float,title:^(Configure — Elisa)$"
        "float,title:^(Add a new game)$"
        "float,title:^(Add games to Lutris)$"
        "float,title:^(Add New Items)$"
        "float,class:^(xfce4-popup-whiskermenu)$"
        "float,class:^(xfce4-terminal)$"
        "float,title:^(Myuzi)$"
        "float,title:^(scratchpad)$"
        "float,class:^(gtkcord4)$"
        "float,class:^(wrapper-2.0)$"
        "float,class:^(gnome-calendar)$"
        "float,title:^(steamwebhelper)$"
        "float,class:^(.blueman-manager-wrapped)$"
        # "float,class:^(pavucontrol)$"
        "float,class:^(gnome-system-monitor)$"
        "float,class:^(gnome-power-statistics)$"
        "float,title:^(Application Launcher)$"
        "float,class:^(Geary)$"
        # "float,class:^(Pavucontrol)$"
        "float,class:^(Syncthing GTK)$"
        "float,class:^(Proton Mail Bridge)$"
        "float,class:^(Zenity)$"

        # Default float rules
        "float,class:^(confirm)$"
        "float,class:^(dialog)$"
        "float,class:^(download)$"
        "float,class:^(error)$"
        "float,class:^(file_progress)$"
        "float,class:^(notification)$"
        "float,class:^(notify)$"
        "float,class:^(popup_menu)$"
        "float,class:^(splash)$"
        "float,class:^(toolbar)$"
        "float,class:^(confirmreset)$"
        "float,class:^(makebranch)$"
        "float,class:^(maketag)$"
        "float,class:^(ssh-askpass)$"
        "float,title:^(branchdialog)$"
        "float,title:^(pinentry)$"

        # Additional system float rules
        "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"
        "float,class:^(nm-applet|nm-connection-editor)$"
        "float,class:^(blueman-manager|blueman-applet)$"
        "float,title:^(File Operation Progress|Progress)$"
        "float,class:^(steam)$,title:^(Friends List|Steam Settings|Steam - News)$"
        "float,class:^(discord|Discord)$,title:^(Discord Updater)$"
        "float,class:^(firefox|librewolf)$,title:^(Picture-in-Picture|Extension: .*)$"
        "float,class:^(pinentry-gtk-2|pinentry-qt)$"
        "float,class:^(xfce4-appfinder|xfce4-notifyd)$"
        "float,class:^(org.gnome.Nautilus|thunar)$,title:^(Open File|Save As)$"

        # Enhanced float settings
        "opacity 0.95,class:^(pinentry.*|dialog|notification)$"
        # "center,class:^(pinentry.*|pavucontrol|notification)$"
        "size 600 400,class:^(pinentry.*|dialog)$"
        "float,xwayland:1,title:^(legacy popup)$"

        "float,class:^(qt5ct)$"
        "float,class:^(qt6ct)$"
        "float,class:^(nvidia-settings)$"
        "float,class:^(.*[Cc]alculator.*)$"
        "float,class:^(.*color.*)$"
        "float,class:^(.*[Gg]pick.*)$"
        "float,class:^(.*file_progress.*)$"
        "float,class:^(.*openfile.*)$"
        "float,class:^(.*savefile.*)$"
        "float, title:^(.*is sharing your screen.*)$"
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

      bind = [
        # ===== SCREENSHOTS =====
        "SUPER, PRINT, exec, hyprshot -m window"
        ", PRINT, exec, hyprshot -m output"
        "SUPERSHIFT, PRINT, exec, hyprshot -m region"
        "ALT, PRINT, exec, XDG_CURRENT_DESKTOP=sway flameshot"

        # ===== APPLICATIONS =====
        "SUPER,I,exec,networkmanager_dmenu"
        "SUPER,T,exec,${userSettings.term}"
        "SUPER,grave,exec,${userSettings.browser}"
        "SUPER,P,exec, kitty --class scratch_term -e ipdf ~"
        "SUPER,O,exec, obsidian"
        "SUPERSHIFT,P,exec,hyprprofile-dmenu"
        "SUPER,F1,exec,fuzzel"
        "SUPER,X,exec,fnottctl dismiss"
        "SUPERSHIFT,X,exec,fnottctl dismiss all"

        # ===== SCRATCHPADS =====
        "SUPER,Z,exec,if hyprctl clients | grep -q scratch_term; then echo \"scratch_term respawn not needed\"; else hyprctl dispatch exec \"[workspace special:scratch_term silent] alacritty --class scratch_term\"; fi"
        "SUPER,Z,togglespecialworkspace,scratch_term"
        "SUPER,F,exec,if hyprctl clients | grep -q scratch_ranger; then echo \"scratch_ranger respawn not needed\"; else kitty --class scratch_ranger -e ranger\"; fi"
        "SUPER,F,togglespecialworkspace,scratch_ranger"
        "SUPER,V,exec,if hyprctl clients | grep -q scratch_thunar; then echo \"scratch_thunar respawn not needed\"; else hyprctl dispatch exec \"[workspace special:scratch_thunar silent] thunar --class scratch_thunar\"; fi"
        "SUPER,V,togglespecialworkspace,scratch_thunar"
        "SUPERSHIFT,B,exec,if hyprctl clients | grep -q scratch_btm; then echo \"scratch_btm respawn not needed\"; else alacritty --class scratch_btm -e btm\"; fi"
        "SUPERSHIFT,B,togglespecialworkspace,scratch_btm"
        "SUPER,code:172,exec,togglespecialworkspace,scratch_pavucontrol"
        "SUPER,code:172,exec,if hyprctl clients | grep -q org.pulseaudio.pavucontrol; then echo \"scratch_ranger respawn not needed\"; else pavucontrol; fi"

        # ===== GROUP MANAGEMENT =====
        "SUPER,slash,togglegroup"
        "SUPER,bracketright,changegroupactive,f"
        "SUPER,bracketleft,changegroupactive,b"
        "SUPER,comma,lockactivegroup,toggle"

        # ===== WINDOW MANAGEMENT =====
        "SUPER,E,togglefloating"
        "SUPER,SPACE,fullscreen,1"
        "SUPERSHIFT,F,fullscreen,0"
        "SUPER,Y,workspaceopt,allfloat"
        "ALT,TAB,cyclenext"
        "ALT,TAB,bringactivetotop"
        "ALTSHIFT,TAB,cyclenext,prev"
        "ALTSHIFT,TAB,bringactivetotop"
        "SUPER,TAB,hyprexpo:expo, toggle"
        "SUPER,U,focusurgentorlast"
        "SUPER,Q,killactive"

        # ===== CURSOR ZOOM =====
        "SUPER,equal, exec, hyprctl keyword cursor:zoom_factor \"$(hyprctl getoption cursor:zoom_factor | grep float | awk '{print $2 + 0.5}')\""
        "SUPER,minus, exec, hyprctl keyword cursor:zoom_factor \"$(hyprctl getoption cursor:zoom_factor | grep float | awk '{print $2 - 0.5}')\""

        # ===== CLIPBOARD =====
        "SUPER,V,exec,wl-copy $(wl-paste | tr \\n)"

        # ===== SYSTEM CONTROLS =====
        "CTRLALT,Delete,exec,hyprctl kill"
        "SUPERSHIFT,K,exec,hyprctl kill"
        "SUPERSHIFT,Q,exit"
        "SUPERSHIFT,S,exec,systemctl suspend"
        ",switch:on:Lid Switch,exec,loginctl lock-session"
        "SUPERCTRL,L,exec,loginctl lock-session"

        # ===== MEDIA CONTROLS =====
        ",code:122,exec,swayosd-client --output-volume lower"
        ",code:123,exec,swayosd-client --output-volume raise"
        ",code:121,exec,swayosd-client --output-volume mute-toggle"
        ",code:256,exec,swayosd-client --output-volume mute-toggle"
        "SHIFT,code:122,exec,swayosd-client --output-volume lower"
        "SHIFT,code:123,exec,swayosd-client --output-volume raise"

        ",code:232,exec,swayosd-client --brightness lower"
        ",code:233,exec,swayosd-client --brightness raise"

        ",code:237,exec,brightnessctl --device='asus::kbd_backlight' set 1-"
        ",code:238,exec,brightnessctl --device='asus::kbd_backlight' set +1"

        ",code:255,exec,airplane-mode"

        # Workspace navigation with hyprnome
        "SUPERCTRL,right,exec,hyprnome"
        "SUPERCTRL,left,exec,hyprnome --previous"
        "SUPERSHIFT,right,exec,hyprnome --move"
        "SUPERSHIFT,left,exec,hyprnome --previous --move"

        # ===== WORKSPACE NAVIGATION =====
        "SUPER,1,focusworkspaceoncurrentmonitor,1"
        "SUPER,2,focusworkspaceoncurrentmonitor,2"
        "SUPER,3,focusworkspaceoncurrentmonitor,3"
        "SUPER,4,focusworkspaceoncurrentmonitor,4"
        "SUPER,5,focusworkspaceoncurrentmonitor,5"
        "SUPER,6,focusworkspaceoncurrentmonitor,6"
        "SUPER,7,focusworkspaceoncurrentmonitor,7"
        "SUPER,8,focusworkspaceoncurrentmonitor,8"
        "SUPER,9,focusworkspaceoncurrentmonitor,9"

        # Move windows to workspaces (with follow)
        "SUPERSHIFT,1,movetoworkspace,1,follow"
        "SUPERSHIFT,2,movetoworkspace,2,follow"
        "SUPERSHIFT,3,movetoworkspace,3,follow"
        "SUPERSHIFT,4,movetoworkspace,4,follow"
        "SUPERSHIFT,5,movetoworkspace,5,follow"
        "SUPERSHIFT,6,movetoworkspace,6,follow"
        "SUPERSHIFT,7,movetoworkspace,7,follow"
        "SUPERSHIFT,8,movetoworkspace,8,follow"
        "SUPERSHIFT,9,movetoworkspace,9,follow"

        # Move windows to workspaces without follow
        "SUPERALT,1,movetoworkspace,1"
        "SUPERALT,2,movetoworkspace,2"
        "SUPERALT,3,movetoworkspace,3"
        "SUPERALT,4,movetoworkspace,4"
        "SUPERALT,5,movetoworkspace,5"
        "SUPERALT,6,movetoworkspace,6"
        "SUPERALT,7,movetoworkspace,7"
        "SUPERALT,8,movetoworkspace,8"
        "SUPERALT,9,movetoworkspace,9"
      ];

      bindm = [
        "SUPER,mouse:272,movewindow"
        "SUPER,mouse:273,resizewindow"
      ];

      binds = {
        movefocus_cycles_fullscreen = false;
      };

      input = {
        kb_layout = "eu, iq, ru, tr";
        kb_options = "grp:rctrl_rshift_toggle";
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

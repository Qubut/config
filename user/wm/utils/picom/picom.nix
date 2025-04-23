{pkgs, ... }:
let
  picom-24_05 = (import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/24.05.tar.gz";
    sha256 = "1lr1h35prqkd1mkmzriwlpvxcb34kmhc9dnr48gkm8hh089hifmx";
  }) { system = pkgs.system; } ).picom;
in
{
  services.picom = {
    enable = true;
    package = picom-24_05;
    vSync = true;
    backend = "glx";
    wintypes = {
      normal = { shadow = false;};
      tooltip = { shadow = true; opacity = 0.75; focus = true; full-shadow = false; };
      dock = { shadow = false; };
      dnd = { shadow = false; };
      popup_menu = { opacity = 1; };
      dropdown_menu = { opacity = 1; };
      };
    shadow = false;
    shadowOpacity = 0.75;
    shadowOffsets = [
      (-7)
      (-7)
    ];

    shadowExclude = [
      "name = 'Notification'"
      "class_g = 'Conky'"
      "class_g ?= 'Notify-osd'"
      "class_g = 'Cairo-clock'"
      "class_g = 'slop'"
      "class_g = 'Polybar'"
      "_GTK_FRAME_EXTENTS@:c"
    ];

    opacityRules = [
      "90:class_g    = 'xmobar'"
      # "95:class_g    = 'firefox'"
      # "90:class_g    = 'librewolf'"
      "90:class_g    = 'gtkcord4'"
      "90:class_g    = 'bottles'"
      "90:class_g    = 'PrismLauncher'"
      "90:class_g    = 'Navigator'"
      "90:class_g    = 'Rofi'"
      "90:class_g    = 'Geary'"
      "90:class_g    = 'KeePassXC'"
      "90:class_g    = 'gnome-calendar'"
      "90:class_g    = 'NewsFlashGTK'"
      "90:class_g    = 'Pavucontrol'"
    ];

    settings = {
    # use-damage = true;
    # resize-damage = 1; # requires blur
    dbus = false;
    # daemon = true;
    experimental-backends = true;
    animations = true;
    animation-window-mass = 0.5;
    # Open window with zoom animation
    animation-for-open-window = "zoom";

    #Close window with zoom animation
    animation-for-close-window = "zoom";

    # Minimize window with slide-out animation
    animation-for-minimize-window = "slide-out";

    # Unminimize with slide-in animation
    animation-for-unminimize-window = "slide-in";

    animation-stiffness = 180;
    fading = true;  # Enable fading animations
    fade-delta = 10;  # Speed of fade (lower = slower)
    fade-in-step = 0.03;  # Opacity increase per step when fading in
    fade-out-step = 0.03;  # Opacity decrease per step when fading out

    fade-exclude = [
      "class_g = 'Conky'"  # Disable fading for conky (example)
      "class_g = 'Firefox' && window_type = 'utility'"
    ];
    inactive-opacity = 0.9;
    active-opacity = 1.0;
    frame-opacity = 0.8;
    inactive-opacity-override = true;
    shadow-radius = 7;
    corner-radius = 12.0;
    round-borders = 1;
    popup_menu = { opacity = 1.0; };
    dropdown_menu = { opacity = 1.0; };
    rounded-corners-exclude = [
      #"window_type = 'normal'"
      "class_g = 'awesome'"
      "class_g = 'Xmobar'"
      "class_g = 'xmobar'"
      "window_type = 'dock'"
    ];
    no-fading-openclose = false;
    transition-length = 1;
    transition-pow-x = 1;
    transition-pow-y = 1;
    transition-pow-w = 1;
    transition-pow-h = 1;
    size-transition = true;
    no-fading-destroyed-argb = false;
    focus-exclude = [
      "class_g = 'Cairo-clock'"
      "class_g = 'Bar'"                    # lemonbar
      "class_g = 'slop'"                    # maim
    ];
  #   blur =  { # requires: https://github.com/ibhagwan/picom
  #   method = "kawase";  # (kawase is the most common)
  #   strength = 7;  # (higher value = stronger blur)
  #   background = true;  # Enable blur behind transparent windows
  #   blur-background-exclude = [
  #       "window_type = 'dock'"
  #       "window_type = 'desktop'"
  #       "class_g = 'firefox' && focused"
  #       "class_g = 'slop'"
  #     "_GTK_FRAME_EXTENTS@:c"
  #   ];
  # };
  #   blur-background = true;
  #   blur-background-frame = true;
  #   blur-kern = "7x7gaussian";
    mark-wmwin-focused = true;
    mark-ovredir-focused = true;
    detect-rounded-corners = true;
    detect-client-opacity = true;
    detect-transient = true;
    detect-client-leader = true;
    log-level = "info";
    unredir-if-possible = true;
    };

  };
}

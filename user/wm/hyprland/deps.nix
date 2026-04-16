{ pkgs
, pkgs-unstable
, inputs
, config
, userSettings
, ...
}:
let
  pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages =
    with pkgs;
    [
      alacritty
      kitty
      feh
      killall
      polkit_gnome
      nwg-launchers
      libva-utils
      libinput-gestures
      gsettings-desktop-schemas
      wlr-randr
      wtype
      ydotool
      wl-clipboard
      fnott
      keepmenu
      pinentry-gnome3
      wev
      python313
      rofi
      kdePackages.qtwayland
      qt6.qtwayland
      xdg-utils
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      wayland-utils
      wdisplays
      wlroots
      wlsunset
      pavucontrol
      pwvucontrol
      pipewire
      wireplumber
      brightnessctl
      pamixer
      hyprnome
      socat  # For Hyprland IPC socket communication
      jq
      # xdg-desktop-portal-hyprland
      tesseract4
        # python313Packages.tkinter
    ] ++ (with pkgs-unstable; [ kdePackages.wayland-protocols hypridle hyprpicker hyprland-protocols hyprshot ])
    ++ (with pkgs-hyprland; [ hyprsunset hyprpaper ]);
  home.file.".local/share/pixmaps/hyprland-logo-stylix.svg".source = config.lib.stylix.colors {
    template = builtins.readFile ../../pkgs/hyprland-logo-stylix.svg.mustache;
    extension = "svg";
  };
}

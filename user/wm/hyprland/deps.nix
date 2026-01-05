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
      pkgs.zenity
      wlr-randr
      wtype
      ydotool
      wl-clipboard
      fnott
      keepmenu
      pinentry-gnome3
      wev
      python311Packages.pyqt6
      kdePackages.qtwayland
      qt6.qtwayland
      xdg-utils
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      wayland-utils
      wlroots
      wlsunset
      pavucontrol
      pwvucontrol
      pipewire
      wireplumber
      pamixer
      # xdg-desktop-portal-hyprland
      tesseract4
    ] ++ (with pkgs-unstable; [ kdePackages.wayland-protocols hyprlock hypridle hyprpaper hyprpicker hyprland-protocols hyprshot ])
    ++ (with pkgs-hyprland; [ hyprsunset ]);
  home.file.".local/share/pixmaps/hyprland-logo-stylix.svg".source = config.lib.stylix.colors {
    template = builtins.readFile ../../pkgs/hyprland-logo-stylix.svg.mustache;
    extension = "svg";
  };
}

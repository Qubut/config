{
  pkgs,
  inputs,
  config,
  userSettings,
  ...
}:
let
in
{
  home.packages =
    with pkgs;
    [
      python312Packages.qtile-extras
      xclip
      redshift
      redshift-plasma-applet
      gnome.gnome-calendar
      gnome.gnome-system-monitor
      alacritty
      kitty
      feh
      killall
      polkit_gnome
      nwg-launchers
      libva-utils
      libinput-gestures
      gsettings-desktop-schemas
      gnome.zenity
      wlr-randr
      wtype
      ydotool
      wl-clipboard
      pinentry-gnome3
      wev
      hyprshot
      python311Packages.pyqt6
      kdePackages.qtwayland
      qt6.qtwayland
      xdg-utils
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      wayland-protocols
      wayland-utils
      wlroots
      wlsunset
      pavucontrol
      pamixer
      tesseract4
      (pkgs.writeScriptBin "nwggrid-wrapper" ''
        #!/bin/sh
        if pgrep -x "nwggrid-server" > /dev/null
        then
          nwggrid -client
        else
          GDK_PIXBUF_MODULE_FILE=${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache nwggrid-server -layer-shell-exclusive-zone -1 -g adw-gtk3 -o 0.55 -b ${config.lib.stylix.colors.base00}
        fi
      '')
      (pkgs.makeDesktopItem {
        name = "nwggrid";
        desktopName = "Application Launcher";
        exec = "nwggrid-wrapper";
        terminal = false;
        type = "Application";
        noDisplay = true;
        icon = "/home/" + userSettings.username + "/.local/share/pixmaps/hyprland-logo-stylix.svg";
      })
      (pkgs.writeScriptBin "nwg-dock-wrapper" ''
        #!/bin/sh
        if pgrep -x ".nwg-dock-hyprl" > /dev/null
        then
          nwg-dock-hyprland
        else
          nwg-dock-hyprland -f -x -i 64 -nolauncher -a start -ml 8 -mr 8 -mb 8
        fi
      '')
    ];

}

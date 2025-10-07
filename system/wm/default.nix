{ userSettings, ... }:

{
  imports = [

    ./${userSettings.wm}.nix
    ./xfce.nix
    ./kde.nix
    ./x11.nix
    ./wayland.nix
    ./pipewire.nix
    ./dbus.nix
    ./gnome-keyring.nix
    ./fonts.nix
    ./displaymanager.nix
    ./uwsm.nix
  ];
}

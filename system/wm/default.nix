{ userSettings, lib, ... }:

{
  imports = [
    ./${userSettings.wm}.nix
    ./wayland.nix
    ./pipewire.nix
    ./dbus.nix
    ./gnome-keyring.nix
    ./fonts.nix
    ./displaymanager.nix
  ] ++ lib.optionals (userSettings.wmType == "x11") [
    ./x11.nix
  ];
}

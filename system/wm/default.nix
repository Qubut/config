{ userSettings, ... }:

{
  imports = [

    ./${userSettings.wm}.nix
    ./xfce.nix
    ./kde.nix
    ./x11.nix
  ];
}

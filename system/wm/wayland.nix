{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./gnome-keyring.nix
    ./fonts.nix
  ];

  environment.systemPackages = with pkgs; [
    wayland
    (sddm-chili-theme.override {
      themeConfig = {
        background = config.stylix.image;
        ScreenWidth = 3840;
        ScreenHeight = 2160;
        blur = true;
        recursiveBlurLoops = 3;
        recursiveBlurRadius = 5;
      };
    })
  ];

  # Configure xwayland
}

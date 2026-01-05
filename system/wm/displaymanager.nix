{ pkgs, lib, userSettings, config, ... }:

{
    environment.systemPackages = with pkgs; [
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
  services.displayManager = {
    sddm = {
      enable = (userSettings.dm == "sddm");
      wayland.enable = true;
      enableHidpi = true;
      theme = "chili";
      package = lib.mkForce pkgs.kdePackages.sddm;
    };
    gdm = {
      enable = (userSettings == "gdm");
      wayland = true;
      autoSuspend = true;
      banner = "Welcome to NixOS";
    };
  };
}

{ pkgs, lib, userSettings, ... }:

{
  services.displayManager = {
    sddm = {
      enable = (userSettings == "sddm");
      wayland.enable = true;
      enableHidpi = true;
      theme = "chili";
      package = lib.mkForce pkgs.kdePackages.sddm;
    };
    gdm = {
      enable = (userSettings == "gdm");
      wayland = true;
      autoSuspend = true;
    };
  };
}

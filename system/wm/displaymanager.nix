{ pkgs, lib, userSettings, config, ... }:

let
  sddmTheme = pkgs.where-is-my-sddm-theme;
in
{
  environment.systemPackages = [
    sddmTheme
  ];
  services.displayManager = {
    sddm = {
      enable = (userSettings.dm == "sddm");
      wayland.enable = true;
      enableHidpi = true;
      theme = "where_is_my_sddm_theme";
      package = lib.mkForce pkgs.kdePackages.sddm;
      extraPackages = with pkgs.qt6; [
        qtdeclarative
        qt5compat
        qtvirtualkeyboard
        qtsvg
      ];
      autoNumlock = true;
      settings = {
        Input = {
          XkbLayout = "de,eu,ara,ru,tr";
          XkbVariant = ",,buckwalter,phonetic,";
          XkbOptions = "grp:rctrl_rshift_toggle";
        };
      };
    };
    gdm = {
      enable = (userSettings.dm == "gdm");
      wayland = true;
      autoSuspend = true;
      banner = "Welcome to NixOS";
    };
  };

  services.xserver.xkb = {
    layout = "de,eu,ara,ru,tr";
    variant = ",,buckwalter,phonetic,";
    options = "grp:rctrl_rshift_toggle";
  };
}

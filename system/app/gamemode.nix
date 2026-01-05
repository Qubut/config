{ pkgs, ... }:

{
  # Feral GameMode
  environment.systemPackages = with pkgs;[
    gamemode
    (lutris.override {
        extraPkgs = pkgs: [
         # List package dependencies here
        ];
        extraLibraries =  pkgs: [
        # List library dependencies here
        ];
      }
    )
    mangohud # for gaming performance metrics
    gamescope
    protonup-qt
    wineWowPackages.stable

    # support 32-bit only
    # wine

    # support 64-bit only
    (wine.override { wineBuild = "wine64"; })

    # support 64-bit only
    # wine64

    # wine-staging (version with experimental features)
    wineWowPackages.staging

    # winetricks (all versions)
    winetricks

    # native wayland support (unstable)
    wineWowPackages.waylandFull
  ];
  # programs.lutris = {
  #   enable = true;
  #   package = pkgs.lutris;
  #   extraPackages = with pkgs; [
  #     mangohud
  #     winetricks
  #     gamescope
  #     gamemode
  #     umu-launcher
  #     protontricks
  #     vulkan-tools
  #   ];
  #   winePackages = [ pkgs.wineWowPackages.full ];
  # };
  programs.gamescope = {
    enable = true;
  };
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };
}

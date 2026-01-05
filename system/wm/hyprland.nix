{ inputs, pkgs, lib, ... }: let
  pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system};
in
{
  # Import wayland config
  imports = [ ./wayland.nix
              ./pipewire.nix
              ./dbus.nix
            ];

  # Security
  security = {
    pam.services.login.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;

  programs = {
    hyprland = {
      withUWSM = true;
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland = {
        enable = true;
      };
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
  };
  environment = {
    plasma6.excludePackages = [ pkgs.kdePackages.systemsettings ];
  };
  services.xserver.excludePackages = [ pkgs.xterm ];
}

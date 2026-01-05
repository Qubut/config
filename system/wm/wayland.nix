{
  config,
  pkgs,
  lib,
  ...
}:

{

  environment.systemPackages = with pkgs; [ wayland egl-wayland ];

  # Configure xwayland
}

{ pkgs, ... }:
{
  virtualisation.waydroid.enable = false;
  environment.systemPackages = [ pkgs.waydroid ];
}

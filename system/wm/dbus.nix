{ pkgs, ... }:

{
  services.dbus = {
    enable = true;
    packages = [ pkgs.dconf ];
    implementation = "broker";
  };

  programs.dconf = {
    enable = true;
  };
}

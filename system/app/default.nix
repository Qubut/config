{lib, pkgs, userSettings, ...}:
{
    imports = [
    (import ./docker.nix {
      storageDriver = null;
      inherit pkgs userSettings lib;
    })
    ./waydroid.nix
    ./virtualization.nix
    ./gamemode.nix
    ./steam.nix
  ];
  programs.xfconf.enable = true;
  programs.thunar.enable = true;
  programs.nm-applet.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
}

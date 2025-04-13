{ pkgs }:
{
  baseSystemSettings = {
    timeZone = "Europe/Berlin";
    locale = "en_US.UTF-8";
    bootMode = "uefi";
    bootMountPath = "/boot";
    grubDevice = ""; # Only used for legacy (BIOS) boot mode
    gpuType = "nvidia"; # Supports slight mods for AMD currently
  };
  userSettings = rec {
    username = "falcon";
    name = "Falcon";
    dotfilesDir = "~/.dotfiles";
    theme = "ayu-dark";
    wm = "qtile"; # Must match selections in ./user/wm/ and ./system/wm/
    wmType = if (wm == "hyprland") then "wayland" else "x11";
    browser = "firefox"; # Must match selection in ./user/app/browser/
    term = "kitty";
    font = "DejaVu Sans Mono";
    fontPkg = pkgs.dejavu_fonts;
    editor = "helix";
  };
  machines = [
    { hostname = "snowfire"; profile = "static"; }
    { hostname = "snowfire"; profile = "mobile"; }
  ];
}

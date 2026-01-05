{ pkgs }:
{
  baseSystemSettings = {
    timeZone = "Europe/Berlin";
    locale = "en_US.UTF-8";
    bootMode = "uefi";
    bootMountPath = "/boot";
    grubDevice = ""; # Only used for legacy (BIOS) boot mode
    gpuType = "nvidia"; # Supports slight mods for AMD currently
    cpuType = "intel";
    cpuHasGpu = true;
  };
  userSettings = rec {
    username = "falcon";
    name = "Falcon";
    dotfilesDir = "~/.dotfiles";
    theme = "ayu-dark";
    wm = "hyprland"; # Must match selections in ./user/wm/ and ./system/wm/
    wmType = if (wm == "hyprland") then "wayland" else "x11";
    dm = "sddm";
    browser = "firefox"; # Must match selection in ./user/app/browser/
    term = "kitty";
    font = "DejaVu Sans Mono";
    fontPkg = pkgs.dejavu_fonts;
    editor = "helix";
    atuinServerPort = 8888;
  };
  machines = [
    { hostname = "snowfire"; profile = "static"; }
    { hostname = "snowfire"; profile = "mobile"; }
  ];
}

{ lib, systemSettings, ... }:
{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./locale.nix
    ./memory.nix
    ./opengl.nix
    ./power.nix
    ./printing.nix
    ./systemd.nix
    ./time.nix
  ] ++ lib.optional (systemSettings.gpuType == "amd")    ./amd.nix
    ++ lib.optional (systemSettings.gpuType == "nvidia") ./nvidia.nix;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
}

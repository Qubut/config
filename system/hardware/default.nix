{...}:
{
  imports = [
   ./audio.nix
   ./bluetooth.nix
   ./locale.nix
   ./memory.nix
   ./nvidia.nix
   ./opengl.nix
   ./power.nix
   ./printing.nix
   ./systemd.nix
   ./time.nix
  ];
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
}

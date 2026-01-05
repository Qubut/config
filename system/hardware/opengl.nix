{ pkgs, systemSettings, ... }:
let
  cpuType = systemSettings.cpuType;
  intel-media-drivers = if cpuType == "intel" then [ pkgs.intel-media-driver ] else [];
in
{
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    libvdpau-va-gl
  ] ++ intel-media-drivers;

  environment.sessionVariables =
    if cpuType == "intel" then { LIBVA_DRIVER_NAME = "iHD"; }
    else {};
}

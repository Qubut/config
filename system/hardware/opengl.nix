{ pkgs, systemSettings, ... }:
let
  cpuType = systemSettings.cpuType;
  gpuType = systemSettings.gpuType;
  isAmd = gpuType == "amd";

  # Non-AMD systems get the OpenGL→VDPAU bridge; AMD gets native support via mesa (already included)
  gpu-packages =
    if isAmd then []
    else [ pkgs.libvdpau-va-gl ];

  cpu-packages =
    if cpuType == "intel" then [ pkgs.intel-media-driver ] else [];

  # LIBVA driver follows the *display* GPU.
  # When cpuHasGpu=true the Intel iGPU drives all outputs (muxless hybrid) → iHD.
  # Only use radeonsi when AMD is the sole/primary display GPU.
  libvaDriver =
    if systemSettings.cpuHasGpu && cpuType == "intel" then "iHD"
    else if isAmd then "radeonsi"
    else if cpuType == "intel" then "iHD"
    else null;
in
{
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = gpu-packages ++ cpu-packages;

  environment.sessionVariables =
    if libvaDriver != null then { LIBVA_DRIVER_NAME = libvaDriver; }
    else {};
}

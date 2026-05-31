{ ... }:
{
  # Early KMS — amdgpu in initrd eliminates sluggish init and compositor races
  hardware.amdgpu.initrd.enable = true;
  # ROCm OpenCL support
  hardware.amdgpu.opencl.enable = true;

  # modesetting is the modern DDX for amdgpu (xf86-video-amdgpu deprecated since ~2021)
  services.xserver.videoDrivers = [ "modesetting" ];

  # D-Bus GPU selection daemon — apps with PrefersNonDefaultGPU=true in their .desktop
  # (Steam, GNOME apps, Flatpaks) automatically launch on AMD without CLI intervention
  services.switcherooControl.enable = true;

  # Broken runtime PM suspend path on several AMD chipsets (Kaby Lake G Vega M GL).
  # mem_sleep_default=deep: S3 deep sleep instead of s2idle which is unreliable on AMD.
  boot.kernelParams = [
    "amdgpu.runpm=0"
    "mem_sleep_default=deep"
  ];

  # On muxless hybrid Intel+AMD, AMD has no KMS resources so the compositor runs on Intel.
  # DRI_PRIME=1 makes all Mesa/Vulkan apps render on the non-primary GPU (AMD renderD128)
  # automatically for every session without any per-app configuration.
  # environment.sessionVariables.DRI_PRIME = "1";
}

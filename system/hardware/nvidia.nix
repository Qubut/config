{ pkgs
, config
, lib
, systemSettings
, ...
}:
let
  cpuBusId =
    if systemSettings.cpuType == "intel" && systemSettings.cpuHasGpu then {
      intelBusId = "PCI:0:2:0";
    } else if systemSettings.cpuHasGpu then {
      amdgpuBusId = "PCI:54:0:0";
    } else { };
  gpuBusId =
    if systemSettings.gpuType == "nvidia" then {
      nvidiaBusId = "PCI:1:0:0";
    } else if systemSettings.gpuType == "amd" then {
      amdgpuBusId = "PCI:54:0:0";
    } else { };
in
{
  environment.systemPackages = with pkgs; [
    mesa
    mesa-demos # For debugging tools like 'glxinfo'
  ];
  services.xserver.videoDrivers = [ "nvidia" ]; # unfree
  hardware = {
    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = true;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      prime = {
        sync.enable = true;
        offload = {
          enable = false;
          enableOffloadCmd = false;
        };
      } // cpuBusId // gpuBusId;
    };
  };
  specialisation = {
    on-the-go.configuration = {
      system.nixos.tags = [ "on-the-go" ];
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce true;
        prime.offload.enableOffloadCmd = lib.mkForce true;
        prime.sync.enable = lib.mkForce false;
      };
    };
  };
}

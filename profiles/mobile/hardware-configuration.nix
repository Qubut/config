{
  config,
  lib,
  pkgs,
  modulesPath,
  systemSettings,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [
    "dm-snapshot"
  ];
  boot.kernelModules = [
    "kvm-intel"
    "cpufreq_powersave"
    "i2c-dev"
    "i2c-piix4"
    "acpi_video"
    (
      if systemSettings.gpuType == "amd" then
        "amdgpu"
      else if systemSettings.gpuType == "nvidia" then
        "nvidia"
      else
        "i915"
    )
  ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [
    "ntfs"
    "ext4"
    "fat32"
    "btrfs"
  ];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a11450a2-7e66-4b4b-a6bb-677d278c8e83";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3803-4EBB";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/e06879a6-74f9-4630-a0ff-d817c39d5af6";
    fsType = "ext4";
  };

  swapDevices = [ ];
  nixpkgs.hostPlatform = lib.mkDefault systemSettings.system;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

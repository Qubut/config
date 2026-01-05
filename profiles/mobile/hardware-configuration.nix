{ config
, lib
, pkgs
, modulesPath
, systemSettings
, ...
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
    device = "/dev/dm-3";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p9";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/dm-0";
    fsType = "ext4";
  };

  nixpkgs.hostPlatform = lib.mkDefault systemSettings.system;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

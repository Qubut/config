{ config
, lib
, pkgs
, modulesPath
, systemSettings
, ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
  };
  fileSystems."/boot" = {
    options = [ "umask=0077" ]; # owner read/write only
  };

  # This is the official way to handle the random seed warning
  boot.tmp.useTmpfs = true; # recommended
  boot.tmp.tmpfsSize = "50%";
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
  boot.initrd.postDeviceCommands = ''
    for led in /sys/class/leds/*::numlock; do
      [ -e "$led/brightness" ] || continue
      echo 1 > "$led/brightness" || true
    done
  '';
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelParams = [
    "resume_offset=533760"
  ];
  boot.resumeDevice = "/dev/disk/by-label/nixos";
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

  nixpkgs.hostPlatform = lib.mkDefault systemSettings.system;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

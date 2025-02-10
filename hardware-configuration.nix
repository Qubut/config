# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.initrd.luks.devices."cryptroot".device = "/dev/nvme0n1p2";
  boot.kernel.sysctl."kernel.sysrq" = 1;
  boot.kernelPackages = pkgs.linuxPackages_zen;
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
    "nvidia"
  ];
  boot.kernelModules = [
    "kvm-intel"
    "nvidia"
    "cryptd"
    "cpufreq_powersave"
    "i2c-dev"
    "i2c-piix4"
  ];
  boot.kernelParams = [
    "nvidia-drm.fbdev=1"
  ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [
    "ntfs"
    "ext4"
    "fat32"
    "btrfs"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f52f15c7-be65-475b-a4e7-162c6762e077";
    fsType = "btrfs";
    options = [
      "subvol=@root"
      "compress=zstd:3" # Uses Zstandard compression with level 3 for a balance of speed and compression ratio.
      "autodefrag" # Automatically defragments small files, beneficial for frequently modified files.
      "noatime" # Prevents write operations when files are read, improving performance.
      "space_cache=v2" # Enables space cache v2, which optimizes space management and reduces fragmentation.
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/38A2-D1FD";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/f52f15c7-be65-475b-a4e7-162c6762e077";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=zstd:3" # Compression for the Nix store subvolume.
      "space_cache=v2" # Improved space management.
      "noatime" # Prevents unnecessary write operations.
    ];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/f52f15c7-be65-475b-a4e7-162c6762e077";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=zstd:3"
      "autodefrag"
      "noatime"
      "space_cache=v2"
    ];
  };

  fileSystems."/mnt/shared" = {
    device = "/dev/mapper/vg_main-shared";
    fsType = "btrfs";
    options = [
      "rw"
      "subvol=@shared"
      "nofail" # Prevent system from failing if this drive doesn't mount
      "space_cache=v2"
      "compress=zstd:3"
      "noatime"
    ];
  };

  fileSystems."/mnt/games" = {
    device = "/dev/mapper/vg_main-shared";
    fsType = "btrfs";
    options = [
      "rw"
      "subvol=@games"
      "nofail"
      "space_cache=v2"
      "compress=zstd:3"
      "noatime"
    ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp47s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp46s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

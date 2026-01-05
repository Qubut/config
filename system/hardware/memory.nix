{ ... }:
{
  services.earlyoom = {
    enable = true;
    enableNotifications = true;
    # extraArgs = [
    #   "--prefer '(^|/)(nix-build|cc1plus|ld|clang|gcc|make|ninja|rustc)'"
    #   "--avoid '(^|/)(bash|sshd|systemd|kwin_x11|plasmashell|Xorg|gnome-shell)'"
    # ];
  };
  # Enhanced memory management
  boot.kernel.sysctl = {
    "vm.swappiness" = 60;
    "vm.vfs_cache_pressure" = 50;
  };
  # Add zram for better memory management
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100; # Higher priority to prefer zram over disk swap
  };
  swapDevices = [{
    device = "/dev/mapper/vg_main-swap";
    priority = 10; # Lower priority than zram
  }];
  boot = {
    resumeDevice = "/dev/mapper/vg_main-swap"; # Use the swap device for hibernation
   initrd.services.lvm.enable = true;
  };
  powerManagement.enable = true;
}

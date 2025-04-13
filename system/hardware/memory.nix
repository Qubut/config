{ ... }:
{
  services.earlyoom = {
    enable = true;
    enableNotifications = true;
    extraArgs = [
      "--prefer '(^|/)(nix-build|cc1plus|ld|clang|gcc|make|ninja|rustc)'"
      "--avoid '(^|/)(bash|sshd|systemd|kwin_x11|plasmashell|Xorg|gnome-shell)'"
    ];
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
    memoryPercent = 100;
  };
}

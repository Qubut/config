{ ... }:

{
  services.journald.extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
  services.journald.rateLimitBurst = 500;
  services.journald.rateLimitInterval = "30s";
  systemd = {
    slices."nix-daemon".sliceConfig = {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = "50%";
    };
    services."nix-daemon" = {
      serviceConfig = {
        Slice = "nix-daemon.slice";
        OOMScoreAdjust = 1000; # Prefer killing build processes
        MemoryHigh = "80%";
        MemoryMax = "90%";
      };
    };
  };
}

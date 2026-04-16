{ ... }:

{
  services.journald = {
    extraConfig = "SystemMaxUse=250M\nSystemMaxFiles=10";
    rateLimitBurst = 500;
    rateLimitInterval = "30s";
  };
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

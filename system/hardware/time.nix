{ systemSettings, ... }:

{
  services.timesyncd.enable = true;
  time.timeZone = systemSettings.timeZone;
}

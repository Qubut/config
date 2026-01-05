{pkgs, ...}:

{
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };
  services.power-profiles-daemon.enable = false;
  # services.displayManager.defaultSession = "plasma";
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
  plasma-browser-integration
  konsole
  oxygen
];
  environment.systemPackages = with pkgs; [ kdePackages.kirigami ];
}

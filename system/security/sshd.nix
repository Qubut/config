{ userSettings, authorizedKeys ? [], ... }:

{
  # Enable incoming ssh
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ userSettings.username ];
      MaxAuthTries = 3;
      LoginGraceTime = "30s";
      X11Forwarding = false;
    };
  };
  # users.users.${userSettings.username}.openssh.authorizedKeys.keys = authorizedKeys;
}

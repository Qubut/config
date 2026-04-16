{ ... }:

{
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    findtime = "10m";
    bantime = "1h";
    ignoreIP = [
      "127.0.0.0/8"
      "::1"
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
    ];
  };
}

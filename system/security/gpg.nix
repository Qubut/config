{ pkgs, lib, ... }:

{
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableExtraSocket = true;
    enableBrowserSocket = true;
    pinentryPackage = pkgs.pinentry-qt;
    settings = {
      # Security-focused cache settings
      default-cache-ttl = 3600; # 1 hour for GPG
      default-cache-ttl-ssh = 1800; # 30 minutes for SSH
      max-cache-ttl = 7200; # Max 2 hours
      max-cache-ttl-ssh = 3600; # Max 1 hour for SSH
      # Security hardening
      allow-loopback-pinentry = "";
      no-allow-external-cache = "";
      # Passphrase constraints
      enforce-passphrase-constraints = "";
      min-passphrase-len = 12;
      min-passphrase-nonalpha = 1;
    };
  };
}

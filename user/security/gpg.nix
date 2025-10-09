{ config, pkgs, ... }:

{
  programs.gpg = {
    enable = true;

    # Security: Use immutable keyring for reproducible configurations
    mutableKeys = false;     # Keyring managed by Nix, immutable
    mutableTrust = false;    # Trust database managed by Nix

    homedir = "${config.xdg.dataHome}/gnupg";

    # Use latest stable GPG package
    package = pkgs.gnupg;

    # Public keys to preload (for verification, encryption to known recipients)
    publicKeys = [
      # Example: Import specific public keys
      # {
      #   source = ./public-keys/colleague.asc;
      #   trust = 5; # ultimate trust
      # }
    ];

    # Smartcard daemon configuration
    scdaemonSettings = {
      # Security: disable CCID if not using specific smartcard readers
      # disable-ccid = true;

      # Smartcard timeout
      card-timeout = 30;

      # Force personalization of empty smartcards
      force = false;

      # Reader port (auto-detection is usually fine)
      # reader-port = "Yubikey";
    };

    # Main GPG configuration (gpg.conf)
    settings = {
      # Key and algorithm preferences
      personal-cipher-preferences = "AES256 AES192 AES CAST5";
      personal-digest-preferences = "SHA512 SHA384 SHA256 SHA224";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";

      # Default preferences for new keys
      default-preference-list = "SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed";

      # Key server configuration
      keyserver = "hkps://keys.openpgp.org";
      keyserver-options = {
        "auto-key-retrieve" = true;
        "include-revoked" = false;
      };

      # Encryption behavior
      encrypt-to = "";  # Don't default to encrypting to self
      no-emit-version = true;
      no-comments = true;

      # Security settings
      s2k-cipher-algo = "AES256";
      s2k-digest-algo = "SHA512";
      s2k-mode = 3;           # Iterated salted S2K
      s2k-count = 65011712;   # Strong iteration count

      # Digest and cipher algorithms
      cert-digest-algo = "SHA512";
      cipher-algo = "AES256";
      digest-algo = "SHA512";

      # Compression
      compress-algo = "ZLIB";
      bzip2-compress-level = 9;

      # Key validation
      weak-digest = "SHA1";
      require-cross-certification = true;
      no-symkey-cache = true;

      # Display settings
      keyid-format = "0xlong";
      with-fingerprint = true;
      with-keygrip = true;
      with-subkey-fingerprint = true;

      # Compliance and compatibility
      throw-keyids = true;
      export-options = {
        "export-minimal" = true;
        "export-clean" = true;
      };

      # Agent configuration (complements services.gpg-agent)
      use-agent = true;
      pinentry-mode = "loopback";  # Use pinentry for passphrase entry
    };
  };

  # GPG Agent configuration (separate but related)
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt";  # Match your desktop environment

    # Security-focused cache settings
    defaultCacheTtl = 3600;    # 1 hour for GPG
    defaultCacheTtlSsh = 1800; # 30 minutes for SSH
    maxCacheTtl = 7200;        # Max 2 hours
    maxCacheTtlSsh = 3600;     # Max 1 hour for SSH

    # SSH support
    enableSshSupport = true;
    enableExtraSocket = true;  # For remote forwarding

    # Security hardening
    grabKeyboardAndMouse = true;
    noAllowExternalCache = true;

    # Shell integration
    enableBashIntegration = true;
    enableZshIntegration = true;

    # Smartcard support
    enableScDaemon = true;

    # Additional security configuration
    extraConfig = ''
      # Enforce passphrase constraints
      enforce-passphrase-constraints
      min-passphrase-len 12
      min-passphrase-nonalpha 1

      # Disable insecure features
      no-allow-external-cache
      no-allow-mark-trusted
      allow-loopback-pinentry

      # Connection and resource limits
      max-connections 3
      disable-scdaemon
    '';
  };
}

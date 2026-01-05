{ config, pkgs, lib, ... }:

{
  programs.gpg = {
    enable = true;

    # Security: Use immutable keyring for reproducible configurations
    mutableKeys = false; # Keyring managed by Nix, immutable
    mutableTrust = false; # Trust database managed by Nix

    homedir = "${config.xdg.dataHome}/gnupg";
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
      card-timeout = "30";

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
      keyserver-options = "auto-key-retrieve include-revoked";

      # Encryption behavior
      no-emit-version = "";
      no-comments = "";

      # Security settings
      s2k-cipher-algo = "AES256";
      s2k-digest-algo = "SHA512";
      s2k-mode = "3"; # Iterated salted S2K
      s2k-count = "65011712"; # Strong iteration count

      # Digest and cipher algorithms
      cert-digest-algo = "SHA512";
      cipher-algo = "AES256";
      digest-algo = "SHA512";

      # Compression
      compress-algo = "ZLIB";
      bzip2-compress-level = "9";

      # Key validation
      weak-digest = "SHA1";
      require-cross-certification = "";
      no-symkey-cache = "";

      # Display settings
      keyid-format = "0xlong";
      with-fingerprint = "";
      with-keygrip = "";
      with-subkey-fingerprint = "";

      # Compliance and compatibility
      throw-keyids = "";
      export-options = "export-minimal export-clean";

      # Agent configuration (complements services.gpg-agent)
      use-agent = "";
      pinentry-mode = "loopback"; # Use pinentry for passphrase entry
    };
  };

}

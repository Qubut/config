{ config, pkgs, ... }:

{
  programs.anki =
    {
      enable = true;
      package = pkgs.anki;

      # UI Configuration for professional workflow
      language = "en";
      uiScale = 1.0;
      theme = "followSystem"; # Follow system theme
      style = "native"; # Better integration with desktop
      videoDriver = "opengl";

      # Performance and behavior settings
      reduceMotion = true; # Disable distracting animations
      minimalistMode = true; # Clean interface
      legacyImportExport = false; # Use modern import/export

      # Review interface optimizations
      hideTopBar = true;
      hideTopBarMode = "fullscreen";
      hideBottomBar = true;
      hideBottomBarMode = "fullscreen"; # or "always"
      spacebarRatesCard = true; # Spacebar answers card

      # Answer key bindings for efficiency
      answerKeys = [
        {
          ease = 1;
          key = "left";
        }
        {
          ease = 2;
          key = "up";
        }
        {
          ease = 3;
          key = "right";
        }
        {
          ease = 4;
          key = "down";
        }
      ];

      # Sync configuration for reliability
      sync = {
        autoSync = true; # Sync on profile open/close
        autoSyncMediaMinutes = 15; # Regular media sync
        networkTimeout = 60; # Generous timeout for large collections
        syncMedia = true; # Include audio and images
        # username = "your_username_here";  # Uncomment and set
        # passwordFile = "/path/to/anki_password";  # Use password file for security
        # url = "https://sync.ankiweb.net/";  # Custom sync server if needed
      };

      # Essential productivity addons
      addons = with pkgs.ankiAddons; [
        # Core productivity
        review-heatmap # Track review consistency and streaks
        anki-connect # API for automation and external tools
        adjust-sound-volume # Better audio control for language learning

        # Interface improvements
        reviewer-refocus-card # Better keyboard navigation
        recolor # Professional color schemes

        # Learning efficiency
        passfail2 # Simplified review options for focused learning
      ];
    };

  # Optional: Additional packages that complement Anki
  home.packages = with pkgs; [
    # For media handling in cards
    ffmpeg
    sox
    # For AnkiConnect integrations
    curl
    jq
  ] ;

  # XDG configuration for Anki (if you want to manage config files)
  # xdg.configFile = {
  #   # Custom Anki profiles or settings
  #   "anki/prefs21.json".text = builtins.toJSON {
  #     # Additional settings not covered by home-manager options
  #     "reviewer.scrollable.answer.keys" = [" " "1" "2" "3" "4"];
  #     "reviewer.scrollable.question.keys" = [" "];
  #     "autoStartReviewer" = true;
  #     "pasteKey" = "Ctrl+Shift+V";
  #   };
  # };
}

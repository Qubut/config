{pkgs, ...}:
{
  home.packages = [ pkgs.thunderbird ];
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird;
    settings = {
      # Privacy settings
      "privacy.donottrackheader.enabled" = true;
      "network.cookie.cookieBehavior" = 1;  # Reject all cookies
      "privacy.resistFingerprinting" = true;

      # Calendar configurations
      "calendar.timezone.local" = "Europe/London";
      "calendar.view.minimonth.showWeekNumbers" = true;
      "calendar.integration.notifications" = true;
      "calendar.notifications.alarm" = 2;   # Show alarms in notification center

      # Email client settings
      "mail.shell.checkDefaultClient" = false;
      "mail.startup.enabledMailCheckOnce" = true;  # check mail on startup
      "mail.biff.animate_icon" = false;             # Disable bouncing tray icon
      "mail.paneconfig.dynamic" = true;             # Dynamic toolbar layout

      # Appearance and UI
      "browser.display.use_system_colors" = true;   # Follow system theme
      "mail.uidensity" = 1;                         # Compact view (0=normal, 1=compact)
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable user CSS

      # Performance and updates
      "app.update.auto" = false;
      "mail.spellcheck.inline" = true;
      "general.smoothScroll" = true;
      "layers.acceleration.force-enabled" = true;   # Enable hardware acceleration
    };

    profiles = {
      "hochschule" = {
        isDefault = true;
        settings = {
          "mail.identity.id1.fullName" = "Abdullah Ahmed";
          "mail.identity.id1.useremail" = "s-aahmed@haw-landshut.com";
          "mail.server.server1.hostname" = "xmail.mwn.de";
          "mail.server.server1.type" = "imap";
          "mail.server.server1.userName" = "ads\\la-s-aahmed";
        };
      };
    };
  };
}

{ config, pkgs, ... }:
{
  security.apparmor = {
    enable = true;

    # Enable caching for faster policy loading
    enableCache = true;

    # Kill processes that should be confined but aren't (strict security)
    killUnconfinedConfinables = true; # Set to true for maximum security

    # Additional include paths for custom policies
    includes = {
      local = "/etc/apparmor.d/local";
      custom = "/var/lib/apparmor/local";
      packages = "/run/current-system/sw/etc/apparmor.d";
    };

    # Packages that provide AppArmor profiles
    packages = with pkgs; [
      apparmor-profiles # Common profiles for various applications
      apparmor-utils # Tools for managing AppArmor
    ];

    policies = {
      "deny-network" = {
        profile = ''
          #include <tunables/global>

          /usr/bin/example-app {
            #include <abstractions/base>
            #include <abstractions/nameservice>

            # Deny all network access
            deny network,

            # Allow reading necessary files
            /etc/passwd r,
            /etc/group r,

            # Allow writing to home directory
            @{HOME}/ r,
            @{HOME}/** rw,
          }
        '';
      };

      "firefox-restricted" = {
        profile = ''
          #include <tunables/global>

          profile firefox-restricted /run/current-system/sw/bin/firefox {
            #include <abstractions/base>
            #include <abstractions/fonts>
            #include <abstractions/audio>
            #include <abstractions/nameservice>

            # File access
            @{HOME}/.mozilla/firefox/** rw,
            @{HOME}/Downloads/** rw,

            # Network access
            network inet stream,
            network inet6 stream,

            # Deny access to sensitive areas
            deny @{HOME}/.ssh/** r,
            deny @{HOME}/.gnupg/** r,
            deny /etc/shadow r,
          }
        '';
      };

      "nginx" = {
        profile = ''
          #include <tunables/global>

          profile nginx /run/current-system/sw/bin/nginx {
            #include <abstractions/base>
            #include <abstractions/nameservice>
            #include <abstractions/ssl_certs>

            capability chown,
            capability dac_override,
            capability setgid,
            capability setuid,
            capability net_bind_service,

            /var/log/nginx/* w,
            /var/cache/nginx/** rw,
            /run/nginx/* rw,

            network inet stream,
            network inet6 stream,
          }
        '';
      };
    };
  };

  # Enable D-Bus AppArmor integration
  services.dbus.apparmor = "enabled";
}

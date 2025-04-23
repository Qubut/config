{ config, pkgs, ... }:

let
  # Script to randomize MAC address using macchanger for enhanced privacy
  change-mac = pkgs.writeShellScript "change-mac" ''
    card=$1
    tmp=$(mktemp)
    ${pkgs.macchanger}/bin/macchanger "$card" -s | grep -oP "[a-zA-Z0-9]{2}:[a-zA-Z0-9]{2}:[^ ]*" > "$tmp"
    mac1=$(cat "$tmp" | head -n 1)
    mac2=$(cat "$tmp" | tail -n 1)
    if [ "$mac1" = "$mac2" ]; then
      if [ "$(cat /sys/class/net/"$card"/operstate)" = "up" ]; then
        ${pkgs.iproute2}/bin/ip link set "$card" down &&
        ${pkgs.macchanger}/bin/macchanger -r "$card"
        ${pkgs.iproute2}/bin/ip link set "$card" up
      else
        ${pkgs.macchanger}/bin/macchanger -r "$card"
      fi
    fi
  '';
in
{
  networking.wireless.enable = true;

  networking.wireless.userControlled.enable = true;

  # Store sensitive data (e.g., passwords) in an environment file
  # File should be at /etc/wpa_supplicant.env and readable only by root
  # networking.wireless.environmentFile = "/etc/wpa_supplicant.env";

  # Define wireless networks with secure configurations
  # networking.wireless.networks = {
  #   # Example WPA2-PSK network (home WiFi)
  #   "MyHomeWiFi" = {
  #     psk = "@MY_HOME_PSK@";  # Replaced by value from environment file
  #   };
  #   # Example Eduroam network using EAP-PWD (institutional WiFi)
  #   "eduroam" = {
  #     auth = ''
  #       key_mgmt=WPA-EAP
  #       eap=PWD
  #       identity="@EDUROAM_ID@"
  #       password="@EDUROAM_PASS@"
  #     '';
  #   };
  # };

  # Optional: Uncomment to allow insecure ciphers for legacy networks
  # Use only if you encounter "legacy sigalg disallowed or unsupported" errors
  # networking.wireless.extraConfig = ''
  #   openssl_ciphers=DEFAULT@SECLEVEL=0
  # '';

  # Systemd service to randomize MAC address on startup for privacy
  # Replace "wlan0" with your actual wireless interface (e.g., wlp3s0)
  systemd.services.macchanger = {
    enable = true;
    description = "Randomize MAC address on wlan0";
    wants = [ "network-pre.target" ];
    before = [ "network-pre.target" ];
    bindsTo = [ "sys-subsystem-net-devices-wlan0.device" ];
    after = [ "sys-subsystem-net-devices-wlan0.device" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${change-mac} wlan0";
    };
  };

  # Ensure macchanger is available
  environment.systemPackages = [ pkgs.macchanger ];

  # Optional: Enable WEP support (insecure, use only if required)
  # nixpkgs.overlays = [
  #   (self: super: {
  #     wpa_supplicant = super.wpa_supplicant.overrideAttrs (oldAttrs: rec {
  #       extraConfig = oldAttrs.extraConfig + ''
  #         CONFIG_WEP=y
  #       '';
  #     });
  #   })
  # ];
}

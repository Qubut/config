{ config, pkgs, systemSettings, lib, ... }:
{
  imports = [
    ./wireless.nix
  ];
  programs.nm-applet.enable = true;
  networking.hostName = systemSettings.hostName;
  networking.enableIPv6  = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  networking.firewall.allowedTCPPorts = [ ];
  # networking.wg-quick.interfaces.wg0.configFile = "/home/falcon/.dotfiles/system/networking/wg_config.conf";
  services.cloudflare-warp = {
    enable = true;
  };
}

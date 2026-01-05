{ config, pkgs, systemSettings, lib, ... }:
{
  imports = [
    ./wireless.nix
  ];
  networking.hostName = systemSettings.hostName;
  networking.enableIPv6  = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlo1.useDHCP = lib.mkDefault true;
  networking.firewall.allowedTCPPorts = [ ];
  # networking.wg-quick.interfaces.wg0.configFile = "/home/falcon/.dotfiles/system/networking/wg_config.conf";
  services.cloudflare-warp = {
    enable = true;
  };
}

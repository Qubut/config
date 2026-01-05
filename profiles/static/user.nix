{ pkgs, ... }:
{
  users.users.falcon = {
    isNormalUser = true;
    description = "falcon";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
      "vboxusers"
      "docker"
      "podman"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}

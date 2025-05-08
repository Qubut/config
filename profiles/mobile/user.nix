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
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}

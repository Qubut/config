{ pkgs, userSettings, ... }:
{
  users.users.falcon = {
    isNormalUser = true;
    description = "falcon";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "video"
      "input"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];

  };
  security.doas.extraRules = [{
    users = [];
    keepEnv = true;
    persist = true;
  }];
}

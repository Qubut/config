{ pkgs, userSettings }:
{
  mobile = {
    users.users.${userSettings.username} = {
      isNormalUser = true;
      description = userSettings.username;
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
  };

  static = {
    users.users.${userSettings.username} = {
      isNormalUser = true;
      description = userSettings.username;
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
  };
}

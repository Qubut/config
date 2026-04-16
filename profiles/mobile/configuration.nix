{
  config,
  pkgs,
  lib,
  inputs,
  systemSettings,
  userSettings,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/app
    ../../system/hardware
    ../../system/networking
    ../../system/nix.nix
    ../../system/security
    ../../system/services.nix
    ../../system/shell
    ../../system/style/stylix.nix
    ../../system/wm
    ./disko.nix
    ./user.nix
    (import ../../system/app/docker.nix {
      storageDriver = null;
      inherit pkgs userSettings lib;
    })
    # ../../system/app/waydroid.nix
    # ../../system/app/virtualization.nix
    ../../system/app/gamemode.nix
    ../../system/app/steam.nix
    ../../system/app/xdg.nix
  ];
  programs.nix-ld.enable = true;
  environment.systemPackages = with pkgs; [
    linux-firmware
    vim
    git
    neovim
    helix
    curl
    wget
    zsh
    fzf
    htop
    bat
    lshw
    wpa_supplicant
    wayland-scanner
    kdePackages.qtbase
    timeshift
  ];

  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  services.journald.storage = "persistent";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

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
    ./user.nix
  ];

  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

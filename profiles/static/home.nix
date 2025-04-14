{ config
, pkgs
, userSettings
, ...
}:
{
  home.stateVersion = "24.05";
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;
  programs.home-manager.enable = true;
  imports = [
    ../../user/shell
    ../../user/lang
    ../../user/style/stylix.nix
    ../../user/wm/${userSettings.wm}
    ../../user/apps
  ];
  home.sessionVariables = {
    EDITOR = userSettings.editor;
    TERM = userSettings.term;
    BROWSER = userSettings.browser;
  };

  home.packages = with pkgs; [
    (pkgs.nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
      ];
    })
    xwayland
    tor-browser-bundle-bin
    emacs
    zsh-powerlevel10k
    syncthing
    kitty
    (pkgs.discord.override {
      withOpenASAR = true;
      # withVencord = true;
    })
    wineWowPackages.stable
    winetricks
    protontricks
    bottles
    (lollypop.override { youtubeSupport = false; })
    mate.atril
    pasystray
    # fluffychat
    vdhcoapp
    tigervnc
    vivaldi
    signal-desktop
    libreoffice
    remmina
    obsidian
    gparted
    deno
    sshpass
    mangohud # for gaming performance metrics
    vlc
    xorg.xhost
    whatsapp-for-linux
    openfortivpn
    frostwire-bin
    telegram-desktop
    okular
  ];
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
}

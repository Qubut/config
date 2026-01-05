{ config
, pkgs
, pkgs-devenv
, userSettings
, ...
}:
{
  home.stateVersion = "24.05";
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  imports = [
    ../../user/shell
    ../../user/lang
    ../../user/style/stylix.nix
    ../../user/wm/${userSettings.wm}
    ../../user/apps
    ../../user/security
  ];
  home.sessionVariables = {
    # EDITOR = userSettings.editor;
    TERM = userSettings.term;
    BROWSER = userSettings.browser;
  };
  home.packages = with pkgs; [
    xwayland
    tor-browser
    emacs
    zsh-powerlevel10k
    syncthing
    kitty
    (pkgs.discord.override {
      withOpenASAR = true;
      # withVencord = true;
    })
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
    sshpass
     vlc
    xorg.xhost
    openfortivpn
    frostwire-bin
    telegram-desktop
    xournalpp
    mpv
    zoom-us
    distrobox
    localsend
    gnome-pomodoro
    antigravity
  ] ++ [ pkgs-devenv ];

}

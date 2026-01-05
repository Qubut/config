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
    EDITOR = userSettings.editor;
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
    mangohud # for gaming performance metrics
    vlc
    xorg.xhost
    openfortivpn
    frostwire-bin
    telegram-desktop
    xournalpp
    anki-bin
    mpv
    zoom-us
    distrobox
    localsend
    gnome-pomodoro
    antigravity
  ] ++ [ pkgs-devenv ];
  xdg.enable = true;
  xdg.cacheHome = "${config.home.homeDirectory}/.cache";
  xdg.configHome = "${config.home.homeDirectory}/.config";
  xdg.dataHome = "${config.home.homeDirectory}/.local/share";
  xdg.stateHome = "${config.home.homeDirectory}/.local/state";
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;
  xdg.userDirs.desktop = "${config.home.homeDirectory}/Desktop";
  xdg.userDirs.documents = "${config.home.homeDirectory}/Documents";
  xdg.userDirs.download = "${config.home.homeDirectory}/Downloads";
  xdg.userDirs.music = "${config.home.homeDirectory}/Music";
  xdg.userDirs.pictures = "${config.home.homeDirectory}/Pictures";
  xdg.userDirs.publicShare = "${config.home.homeDirectory}/Public";
  xdg.userDirs.templates = "${config.home.homeDirectory}/Templates";
  xdg.userDirs.videos = "${config.home.homeDirectory}/Videos";
}

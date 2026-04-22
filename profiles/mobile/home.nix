{ config
, pkgs
, pkgs-unstable
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
    ../../user/apps/xdg.nix
    ../../user/apps/thunderbird.nix
    ../../user/apps/gnome-keyring.nix
    ../../user/apps/podman.nix
    ../../user/apps/firefox.nix
    ../../user/apps/networkmanager-dmenu.nix
    ../../user/apps/atuin.nix
    ../../user/apps/neovim.nix
    ../../user/apps/tmux.nix
    ../../user/apps/helix.nix
    ../../user/apps/git.nix
    ../../user/apps/vscodium.nix
    # ../../user/apps/ranger/ranger.nix
    ../../user/security
  ];
  home.sessionVariables = {
    # EDITOR = userSettings.editor;
    TERM = userSettings.term;
    BROWSER = userSettings.browser;
  };
  home.packages = with pkgs; [
    xwayland
    emacs
    zsh-powerlevel10k
    syncthing
    kitty
    (pkgs.discord.override {
      withOpenASAR = true;
      # withVencord = true;
    })
    mate.atril
    pasystray
    # fluffychat
    tigervnc
    vivaldi
    libreoffice
    remmina
    obsidian
    sshpass
    vlc
    xorg.xhost
    openfortivpn
    xournalpp
    mpv
    localsend
    jetbrains.datagrip
    gh
    zoom-us
  ] ++ [ pkgs-devenv ] ++ (with pkgs-unstable; [ code-cursor cursor-cli ]);

}

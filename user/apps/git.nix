{ config
, pkgs
, userSettings
, ...
}:

{
  home.packages = with pkgs; [
    git
    lazygit
    git-filter-repo
  ];
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      aliases = {
        ci = "commit";
        co = "checkout";
        s = "status";
      };
      user = {
        email = "s-aahmed@haw-landshut.de";
        name = "Qubut";
      };
      init.defaultBranch = "main";
      safe.directory = [
        ("/home/" + userSettings.username + "/.dotfiles")
        ("/home/" + userSettings.username + "/.dotfiles/.git")
      ];
    };
  };
}

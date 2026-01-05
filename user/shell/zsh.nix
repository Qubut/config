{
  config,
  pkgs,
  userSettings,
  ...
}:
let
  aliases = builtins.readFile ./zsh-aliases;
  functions = builtins.readFile ./zsh-functions;
  xdgStateHome = builtins.getEnv "XDG_STATE_HOME";
  p10k = builtins.readFile ./p10k.zsh;
in
{
  programs.zsh = {
    enable = true;
    prezto = {
      enable = true;
      pmodules = [
        "editor"
        "history"
        "completion"
        "prompt"
        "syntax-highlighting"
        "autosuggestions"
        "directory"
        "utility"
        "git"
        "history-substring-search"
        "tmux"
        "ssh"
        "spectrum"
      ];
      prompt.theme = "powerlevel10k";
      tmux.autoStartLocal = true;
      tmux.defaultSessionName = "autostart";
      extraConfig = ''
        zstyle ':prezto:module:history-substring-search' unique 'yes'
      '';
    };
    history = {
      size = 10000;
      path = "${config.xdg.stateHome}/zsh/history";
      extended = true;
      ignoreSpace = true;
    };
    dotDir = "${config.xdg.configHome}/zsh";
    initContent = ''
      ${aliases}
      ${functions}
      ${p10k}
    '';
  };
}

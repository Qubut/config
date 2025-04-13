{ config
, pkgs
, userSettings
, ...
}:
let
  aliases = builtins.readFile ./zsh-aliases;
  functions = builtins.readFile ./zsh-functions;
in
{
  home.packages = [
    pkgs.ble-sh # For syntax highlighting, autosuggestions, and history search
    pkgs.starship # For a customizable prompt
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;

    historySize = 10000;
    historyFile = "${config.xdg.stateHome}/bash/history";
    historyFileSize = 100000;
    historyControl = [ "ignorespace" "ignoredups" ];

    initExtra = ''
      # Add timestamps to history (similar to Zsh's extended history)
      export HISTTIMEFORMAT="%F %T "

      # Load aliases and functions
      ${aliases}
      ${functions}

      # Source ble.sh for syntax highlighting, autosuggestions, and history search
      [[ -f ${pkgs.ble-sh}/share/ble.sh ]] && source ${pkgs.ble-sh}/share/ble.sh

      # Auto-start tmux, matching Zsh's behavior
      if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
        exec tmux new-session -A -s autostart
      fi
    '';
  };

  # Enable starship prompt
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
}

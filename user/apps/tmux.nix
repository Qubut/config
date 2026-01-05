{
  config,
  pkgs,
  lib,
  fetchFromGitHub,
  userSettings,
  ...
}:
let
  wmType = userSettings.wmType;
  mkTmuxPlugin = pkgs.tmuxPlugins.mkTmuxPlugin;
  # tmux-sessionx = mkTmuxPlugin {
  #   pluginName = "sessionx";
  #   version = "unstable-2024-08-16";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "omerxx";
  #     repo = "tmux-sessionx";
  #     rev = "ecc926e7db7761bfbd798cd8f10043e4fb1b83ba";
  #     sha256 = "1qa2a4m75w6k64f52fsw9k6yyiidlxm2q31w8hrsjd5bcdr6dzab";
  #   };
  # };

  # tmux-fzf-url = mkTmuxPlugin {
  #   pluginName = "tmux-fzf-url";
  #   version = "stable-2024-08-16";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "junegunn";
  #     repo = "tmux-fzf-url";
  #     rev = "dc701c41cfd32de0c8271c203d5e91875330320c";
  #     sha256 = "0miaq053x82ps7v55by28wzbwd6fm59ambzm4l10yk2cgw3ij99y";
  #   };
  # };
  # tmux-fzf = mkTmuxPlugin {
  #   pluginName = "tmux-fzf";
  #   version = "stable-2024-08-16";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "sainnhe";
  #     repo = "tmux-fzf";
  #     rev = "1547f18083ead1b235680aa5f98427ccaf5beb21";
  #     sha256 = "10yhv9blamy3ha3lljz96s84y064dxs627xpwckd10n4vspszjkl";
  #   };
  # };
in
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [
      # better-mouse-mode
      # yank
      # resurrect
      # continuum
      # tmux-fzf
      # tmux-fzf-url
    ];
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -g renumber-windows on
      setw -g mode-keys vi
      set -g pane-active-border-style 'fg=magenta,bg=default'
      set -g pane-border-style 'fg=brightblack,bg=default'
      set -g mouse on
      # splitting panes with | and -
      bind | split-window -h
      bind - split-window -v
      # moving between panes with Prefix h,j,k,l
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      # Quick window selection
      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+
      # Pane resizing panes with Prefix H,J,K,L
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      # enable vi keys.
      setw -g mode-keys vi
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${
        if wmType == "wayland" then "wl-copy" else "xclip -selection clipboard -i"
      }"
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${
        if wmType == "wayland" then "wl-copy" else "xclip -selection clipboard -i"
      }; display-message 'Copied to clipboard'"
      run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
      set -g @catppuccin_flavour 'mocha'
      set -g @catppuccin_window_left_separator ""
      set -g @catppuccin_window_right_separator " "
      set -g @catppuccin_window_middle_separator " █"
      set -g @catppuccin_window_number_position "right"
      set -g @catppuccin_window_default_fill "number"
      set -g @catppuccin_window_default_text "#W"
      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
      set -g @catppuccin_status_modules_right "directory meetings date_time"
      set -g @catppuccin_status_modules_left "session"
      set -g @catppuccin_status_left_separator  " "
      set -g @catppuccin_status_right_separator " "
      set -g @catppuccin_status_right_separator_inverse "no"
      set -g @catppuccin_status_fill "icon"
      set -g @catppuccin_status_connect_separator "no"
      set -g @catppuccin_directory_text "#{b:pane_current_path}"

    '';
  };
}

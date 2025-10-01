{ config, pkgs, ... }:
let
  baseColors = config.lib.stylix.colors;
  toHex = color: "0x${color}";
in
{
  programs.atuin = {
    enable = true;

    # Enable shell integrations based on what shells you use
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = false;  # Set to true if you use Fish
    enableNushellIntegration = false; # Set to true if you use Nushell

    # Optional: Use a specific package version
    # package = pkgs.atuin;

    # Flags to append to the shell hook
    flags = [
      "--disable-up-arrow"
    ];

    # Configuration settings
    settings = {
      # Sync settings
      sync_address = "https://api.atuin.sh";
      sync_enabled = false;

      # Search settings
      search_mode = "fuzzy";  # fuzzy, prefix, fulltext
      filter_mode = "global"; # global, host, session, directory
      show_preview = true;

      # UI settings
      style = "compact";      # compact, full
      show_help = false;
      exit_mode = "return-query"; # return-query, return-original, close

      # History settings
      history_limit = 100000;
      history_filter = [
        "^ls$"
        "^cd$"
        "^cd .*$"
        "^pwd$"
        "^exit$"
        "^date$"
        "^history$"
      ];

      # Keybinding settings
      ctrl_n_shortcuts = true;
      ctrl_r_shortcuts = true;

      # Database settings
      db_path = "${config.xdg.dataHome}/atuin/history.db";

      # Enter key behavior
      enter_accept = false;   # Press enter to accept, vs ctrl+enter

      # Workspace settings
      workspaces = false;

      # Auto-sync settings
      auto_sync = true;
      sync_frequency = "10m";

      # Privacy settings
      record_time = true;
      db_wal = true;

      # Keymap settings (optional)
      keymap_mode = "auto";   # auto, vi-ins, vi-cmd, emacs
    };

    # Custom themes (optional)
    themes = {
      stylix = {
        bg = toHex baseColors.base00;
        fg = toHex baseColors.base05;
        border = toHex baseColors.base02;
        border_focused = toHex baseColors.base0D;
        result_bg = toHex baseColors.base00;
        result_fg = toHex baseColors.base05;
        selected_bg = toHex baseColors.base02;
        selected_fg = toHex baseColors.base05;
        selected_border = toHex baseColors.base0D;
        preview_bg = toHex baseColors.base00;
        preview_fg = toHex baseColors.base05;
        preview_border = toHex baseColors.base02;
        query_bg = toHex baseColors.base00;
        query_fg = toHex baseColors.base05;
        query_border = toHex baseColors.base02;
        status_line_bg = toHex baseColors.base02;
        status_line_fg = toHex baseColors.base05;
        hint_bg = toHex baseColors.base00;
        hint_fg = toHex baseColors.base03;
        mode_bg = toHex baseColors.base0D;
        mode_fg = toHex baseColors.base00;
      };
      # Dark theme
      dark = {
        # Base colors
        bg = "#1e1e2e";
        fg = "#cdd6f4";

        # Border colors
        border = "#313244";
        border_focused = "#cba6f7";

        # Result colors
        result_bg = "#1e1e2e";
        result_fg = "#cdd6f4";

        # Selected result colors
        selected_bg = "#585b70";
        selected_fg = "#cdd6f4";
        selected_border = "#cba6f7";

        # Preview colors
        preview_bg = "#1e1e2e";
        preview_fg = "#cdd6f4";
        preview_border = "#313244";

        # Query colors
        query_bg = "#1e1e2e";
        query_fg = "#cdd6f4";
        query_border = "#313244";

        # Status line colors
        status_line_bg = "#313244";
        status_line_fg = "#cdd6f4";

        # Hint colors
        hint_bg = "#1e1e2e";
        hint_fg = "#a6adc8";

        # Mode colors
        mode_bg = "#cba6f7";
        mode_fg = "#1e1e2e";
      };

      # Light theme
      light = {
        bg = "#fafafa";
        fg = "#383a42";
        border = "#e5e5e6";
        border_focused = "#4078f2";
        result_bg = "#fafafa";
        result_fg = "#383a42";
        selected_bg = "#e5e5e6";
        selected_fg = "#383a42";
        selected_border = "#4078f2";
        preview_bg = "#fafafa";
        preview_fg = "#383a42";
        preview_border = "#e5e5e6";
        query_bg = "#fafafa";
        query_fg = "#383a42";
        query_border = "#e5e5e6";
        status_line_bg = "#e5e5e6";
        status_line_fg = "#383a42";
        hint_bg = "#fafafa";
        hint_fg = "#a0a1a7";
        mode_bg = "#4078f2";
        mode_fg = "#fafafa";
      };

      # Catppuccin Mocha theme
      catppuccin-mocha = {
        bg = "#1e1e2e";
        fg = "#cdd6f4";
        border = "#45475a";
        border_focused = "#cba6f7";
        result_bg = "#1e1e2e";
        result_fg = "#cdd6f4";
        selected_bg = "#585b70";
        selected_fg = "#cdd6f4";
        selected_border = "#cba6f7";
        preview_bg = "#1e1e2e";
        preview_fg = "#cdd6f4";
        preview_border = "#45475a";
        query_bg = "#1e1e2e";
        query_fg = "#cdd6f4";
        query_border = "#45475a";
        status_line_bg = "#45475a";
        status_line_fg = "#cdd6f4";
        hint_bg = "#1e1e2e";
        hint_fg = "#a6adc8";
        mode_bg = "#cba6f7";
        mode_fg = "#1e1e2e";
      };
    };
  };

  # Optional: Additional shell configuration for better integration
  programs.bash.interactiveShellInit = ''
    # Atuin bash-specific settings
    export ATUIN_NOBIND="false"
  '';

  programs.zsh.interactiveShellInit = ''
    # Atuin zsh-specific settings
    export ATUIN_NOBIND="false"
  '';
}

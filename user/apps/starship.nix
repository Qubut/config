{config, pkgs, ...}: {
  imports = [stylix.nix];

  programs.starship = {
    enable = true;
    interactiveOnly = true;

    # Add presets - you can enable multiple and they'll be merged in order
    presets = [
      "nerd-font-symbols"  # Use Nerd Font symbols
      "bracketed-segments" # Use brackets instead of default wording
      "no-empty-icons"     # Don't show icons if toolset not found
    ];

    settings = let
      # Use Stylix colors directly
      base00 = config.lib.stylix.colors.base00; # Default Background
      base01 = config.lib.stylix.colors.base01; # Lighter Background
      base02 = config.lib.stylix.colors.base02; # Selection Background
      base03 = config.lib.stylix.colors.base03; # Comments, Invisibles
      base04 = config.lib.stylix.colors.base04; # Dark Foreground
      base05 = config.lib.stylix.colors.base05; # Default Foreground
      base06 = config.lib.stylix.colors.base06; # Light Foreground
      base07 = config.lib.stylix.colors.base07; # Light Background
      base08 = config.lib.stylix.colors.base08; # Red
      base09 = config.lib.stylix.colors.base09; # Orange
      base0A = config.lib.stylix.colors.base0A; # Yellow
      base0B = config.lib.stylix.colors.base0B; # Green
      base0C = config.lib.stylix.colors.base0C; # Cyan
      base0D = config.lib.stylix.colors.base0D; # Blue
      base0E = config.lib.stylix.colors.base0E; # Purple
      base0F = config.lib.stylix.colors.base0F; # Magenta
    in {
      # Format string with better organization
      format = "$all$fill$status$shell$character";

      # Right prompt format (appears on right side)
      right_format = "$time";

      # Add some spacing between modules
      add_newline = true;

      # Disable blank line at start (cleaner look)
      scan_timeout = 10;

      # Main prompt configuration - compatible with bracketed-segments preset
      character = {
        success_symbol = "[❯](#${base0B})[❯](#${base0C})[❯](#${base0D})";
        error_symbol = "[❯](#${base08})[❯](#${base09})[❯](#${base08})";
        vimcmd_symbol = "[❮](#${base0A})";
        vimcmd_replace_one_symbol = "[❮](#${base09})";
        vimcmd_replace_symbol = "[❮](#${base09})";
        vimcmd_visual_symbol = "[❮](#${base0E})";
      };

      # Username configuration
      username = {
        style_user = "bold #${base0C}";
        style_root = "bold #${base08}";
        format = "[$user]($style)";
        disabled = false;
        show_always = false; # Only show when different from default user
      };

      # Hostname configuration
      hostname = {
        ssh_symbol = "󰢾 ";
        style = "bold #${base0D}";
        format = "[@$hostname]($style)";
        ssh_only = false;
        trim_at = ".local";
        disabled = false;
      };

      # Directory configuration
      directory = {
        style = "bold #${base0D}";
        truncation_length = 3;
        truncation_symbol = "…/";
        home_symbol = "~";
        read_only = " 󰌾";
        read_only_style = "#${base08}";
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };

      # Git branch configuration - using Nerd Font symbols
      git_branch = {
        symbol = "󰊢 ";
        style = "bold #${base0E}";
        format = "[$symbol$branch]($style)";
        truncation_length = 63;
        truncation_symbol = "…";
      };

      # Git status with Nerd Font symbols
      git_status = {
        style = "#${base0A}";
        conflicted = "🏳";
        ahead = "\${count}";
        behind = "\${count}";
        diverged = "\${ahead_count}\${behind_count}";
        up_to_date = "✓";
        untracked = "?\${count}";
        stashed = "󰆍";
        modified = "!\${count}";
        staged = "+\${count}";
        renamed = "»\${count}";
        deleted = "✘\${count}";
        format = "[[$all_status$ahead_behind]]($style)";
      };

      # Git state with Nerd Font symbols
      git_state = {
        style = "#${base09}";
        rebase = "󰘬";
        merge = "󰘬";
        revert = "󰕌";
        cherry_pick = "󰄾";
        bisect = "󰄺";
        am = "󰛃";
        am_or_rebase = "󰛃";
        progress_divider = "/";
        format = "[$state( $progress_current/$progress_total)]($style)";
      };

      # Nix shell configuration with Nerd Font
      nix_shell = {
        symbol = " ";
        style = "bold #${base0C}";
        format = "[$symbol$state( \\($name\\))]($style)";
        impure_msg = "[impure](bold red)";
        pure_msg = "[pure](bold green)";
      };

      # Command duration with threshold
      cmd_duration = {
        format = "[$duration]($style)";
        style = "bold #${base09}";
        min_time = 5000;
        show_milliseconds = false;
        disabled = false;
      };

      # Battery module with Nerd Font symbols
      battery = {
        full_symbol = "󰁹";
        charging_symbol = "󰂄";
        discharging_symbol = "󰁼";
        unknown_symbol = "󰂑";
        empty_symbol = "󰂎";
        format = "[$symbol$percentage]($style)";
        style = "bold #${base0B}";
        display = [
          {
            threshold = 10;
            style = "bold #${base08}";
          }
          {
            threshold = 30;
            style = "bold #${base09}";
          }
        ];
      };

      # Time module for right prompt
      time = {
        format = "[\\[$time\\]]($style)";
        style = "dimmed #${base03}";
        time_format = "%H:%M";
        disabled = false;
        utc_time_offset = "local";
      };

      # Status module
      status = {
        style = "bold #${base08}";
        format = "[$symbol$status]($style)";
        symbol = "✗";
        not_executable_symbol = "󰌾";
        not_found_symbol = "󰍉";
        sigint_symbol = "󰂭";
        signal_symbol = "󱕽";
        success_symbol = "";
        map_symbol = true;
        disabled = false;
      };

      # Shell module
      shell = {
        bash_indicator = "bsh";
        fish_indicator = "fsh";
        zsh_indicator = "zsh";
        powershell_indicator = "psh";
        ion_indicator = "ion";
        elvish_indicator = "esh";
        tcsh_indicator = "tsh";
        nu_indicator = "nu";
        format = "[$indicator]($style)";
        style = "dimmed #${base03}";
        disabled = false;
      };

      # Fill module
      fill = {
        symbol = " ";
        style = "bg:#${base00}";
      };

      # Additional modules with Nerd Font symbols
      package = {
        symbol = "󰏗";
        style = "bold #${base0F}";
        format = "[$symbol$version]($style)";
      };

      python = {
        symbol = "󰌠";
        style = "bold #${base0B}";
        format = "[$symbol$version]($style)";
      };

      nodejs = {
        symbol = "󰎙";
        style = "bold #${base0B}";
        format = "[$symbol$version]($style)";
      };

      rust = {
        symbol = "󱘗";
        style = "bold #${base09}";
        format = "[$symbol$version]($style)";
      };

      golang = {
        symbol = "󰟓";
        style = "bold #${base0C}";
        format = "[$symbol$version]($style)";
      };

      docker_context = {
        symbol = "󰡨";
        style = "bold #${base0D}";
        format = "[$symbol$context]($style)";
        only_with_files = true;
      };

      kubernetes = {
        symbol = "󱃾";
        style = "bold #${base0D}";
        format = "[$symbol$context]($style)";
      };

      # Line break
      line_break = {
        disabled = false;
      };

      # Memory usage module
      memory_usage = {
        symbol = "󰍛";
        style = "bold #${base0E}";
        format = "[$symbol$ram]($style)";
        disabled = false;
        threshold = 75; # Only show if usage is above 75%
      };

      # AWS module
      aws = {
        symbol = "󰸏";
        style = "bold #${base09}";
        format = "[$symbol$profile]($style)";
        disabled = false;
      };
    };
  };
}

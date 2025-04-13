{ config, pkgs, ... }: {
  services.pasystray.enable = false;
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        origin = "bottom-right";
        offset = "10x50";
        transparency = 10;
        progress_bar = true;
        corner_radius = 10;
        frame_width = 2;
        padding = 8;
        horizontal_padding = 8;
        font = "Droid Sans 9";
        separator_color = "frame";
        frame_color = "#${config.lib.stylix.colors.base0D}";
        alignment = "left";
        vertical_alignment = "center";
        line_height = 0;
        markup = "full";
        sort = true;
        idle_threshold = 120;
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
      };

      urgency_low = {
        background = "#${config.lib.stylix.colors.base00}";
        foreground = "#${config.lib.stylix.colors.base05}";
        timeout = 5;
      };

      urgency_normal = {
        background = "#${config.lib.stylix.colors.base00}";
        foreground = "#${config.lib.stylix.colors.base07}";
        timeout = 10;
      };

      urgency_critical = {
        background = "#${config.lib.stylix.colors.base00}";
        foreground = "#${config.lib.stylix.colors.base08}";
        frame_color = "#${config.lib.stylix.colors.base08}";
        timeout = 0;
      };
    };
  };
}

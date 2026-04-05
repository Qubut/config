{ config, pkgs, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
  colors = config.lib.stylix.colors;
  fontName = config.stylix.fonts.sansSerif.name;
  fontSize = toString config.stylix.fonts.sizes.popups;
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = {
      "*" = {
        background = mkLiteral "rgba(${colors.base00-rgb-r}, ${colors.base00-rgb-g}, ${colors.base00-rgb-b}, 0.78)";
        background-alt = mkLiteral "rgba(${colors.base01-rgb-r}, ${colors.base01-rgb-g}, ${colors.base01-rgb-b}, 0.58)";
        foreground = mkLiteral "#${colors.base05}";
        selected = mkLiteral "rgba(${colors.base0D-rgb-r}, ${colors.base0D-rgb-g}, ${colors.base0D-rgb-b}, 0.28)";
        selected-solid = mkLiteral "#${colors.base0D}";
        active = mkLiteral "#${colors.base0B}";
        urgent = mkLiteral "#${colors.base08}";
        border = mkLiteral "#${colors.base03}";
        foreground-alt = mkLiteral "#${colors.base04}";
        font = "${fontName} ${fontSize}";
      };
      "window" = {
        background-color = mkLiteral "@background";
        border = mkLiteral "1px";
        border-color = mkLiteral "@border";
        border-radius = 16;
        padding = 16;
        width = mkLiteral "42%";
      };
      "mainbox" = {
        background-color = mkLiteral "transparent";
        children = map mkLiteral [ "inputbar" "listview" ];
        spacing = 14;
      };
      "inputbar" = {
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "@foreground";
        border = mkLiteral "1px";
        border-color = mkLiteral "transparent";
        border-radius = 12;
        children = map mkLiteral [ "prompt" "entry" ];
        spacing = 10;
        padding = 12;
      };
      "prompt" = {
        text-color = mkLiteral "@selected-solid";
        background-color = mkLiteral "transparent";
        padding = mkLiteral "0px 2px 0px 2px";
      };
      "entry" = {
        text-color = mkLiteral "@foreground";
        background-color = mkLiteral "transparent";
        placeholder = "Search";
        placeholder-color = mkLiteral "@foreground-alt";
      };
      "listview" = {
        background-color = mkLiteral "transparent";
        lines = 10;
        columns = 1;
        scrollbar = false;
        spacing = 8;
      };
      "element" = {
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "@foreground";
        border = mkLiteral "1px";
        border-color = mkLiteral "transparent";
        border-radius = 12;
        padding = 10;
        spacing = 10;
      };
      "element selected" = {
        background-color = mkLiteral "@selected";
        border-color = mkLiteral "@selected-solid";
        text-color = mkLiteral "@foreground";
      };
      "element-text selected" = {
        text-color = mkLiteral "@foreground";
      };
      "element-icon" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        size = mkLiteral "1.15em";
      };
      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
      };
    };
    extraConfig = {
      show-icons = true;
      display-drun = "Applications";
      drun-display-format = "{name}";
      matching = "fuzzy";
      sorting-method = "fzf";
      cycle = true;
      hover-select = true;
    };
  };
}

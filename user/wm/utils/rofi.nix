{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    extraConfig = {
      show-icons = true;
      display-drun = "Applications";
      drun-display-format = "{name}";
      matching = "fuzzy";
      sorting-method = "fzf";
      cycle = true;
      hover-select = true;
      kb-row-up = "Up,Control+k";
      kb-row-down = "Down,Control+j";
    };
  };
}

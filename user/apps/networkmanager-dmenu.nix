{ ... }:
{
  imports = [ ./dmenu-scripts/networkmanager-dmenu.nix ];
  programs.networkmanager-dmenu = {
    enable = true;
    dmenuCommand = "rofi -show dmenu";
    terminal = "alacritty";
  };
}

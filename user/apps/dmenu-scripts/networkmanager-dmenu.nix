{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.networkmanager-dmenu;
in
{
  options.programs.networkmanager-dmenu = {
    enable = mkEnableOption "networkmanager-dmenu";

    dmenuCommand = mkOption {
      type = types.str;
      default = "rofi -show dmenu";
      description = "dmenu command to use";
    };

    terminal = mkOption {
      type = types.str;
      default = "alacritty";
      description = "Terminal to use for editor";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ networkmanager_dmenu networkmanagerapplet ];

    home.file.".config/networkmanager-dmenu/config.ini".text = ''
      [dmenu]
      dmenu_command = ${cfg.dmenuCommand}

      compact = True
      wifi_chars = ▂▄▆█
      list_saved = True

      [editor]
      terminal = ${cfg.terminal}
      # gui_if_available = <True or False> (Default: True)
    '';
  };
}

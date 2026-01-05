{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs;[
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

}

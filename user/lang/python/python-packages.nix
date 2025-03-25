{ pkgs, ... }:

{
  # Python packages
  home.packages = with pkgs.python3Packages; [
  ];
}

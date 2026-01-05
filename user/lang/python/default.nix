{ pkgs, ... }:

{
  imports = [ ./python-packages.nix ];
  home.packages = with pkgs; [
    # Python setup
    python3Packages.python-lsp-server
    python3Packages.pylance
    python3Packages.black
  ];
}

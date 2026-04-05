{ pkgs, ... }:

{
  # Doas instead of sudo
  security.doas.enable = true;
  security.sudo.enable = false;

  environment.systemPackages = [
    (pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
  ];
}

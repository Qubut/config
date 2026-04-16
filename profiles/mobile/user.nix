{ pkgs, userSettings, ... }:
let
  usersConfig = import ../../users.nix { inherit pkgs userSettings; };
in
usersConfig.mobile

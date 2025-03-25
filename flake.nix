{
  description = "User flake";

  inputs = {
    ormolu.url = "github:tweag/ormolu";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    blocklist-hosts = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/Hyprland.git";
      submodules = true;
      # rev = "c7b72790bd63172f04ee86784d4cb2a400532927"; # v0.42.0
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/hyprland-plugins.git";
      # rev = "b73d7b901d8cb1172dd25c7b7159f0242c625a77"; # v0.42.0
      inputs.hyprland.follows = "hyprland";
    };
    hyprlock = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/hyprlock.git";
      # rev = "58e1a4a4997728be886a46d031514b3f09763c5d";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nwg-dock-hyprland-pin-nixpkgs.url = "nixpkgs/2098d845d76f8a21ae4fe12ed7c7df49098d3f15";
    xmonad-contexts = {
      url = "github:Procrat/xmonad-contexts";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-nwg-dock-hyprland = import inputs.nwg-dock-hyprland-pin-nixpkgs {
        system = systemSettings.system;
      };
      pkgs-haskell-ormolu = inputs.ormolu.packages.${system}.default;
      systemSettings = {
        system = "x86_64-linux";
        hostName = "snowfire";
        profile = "static";
        timeZone = "Europe/Berlin";
        locale = "en_US.UTF-8";
        bootMode = "uefi";
        bootMountPath = "/boot";
        grubDevice = ""; # device identifier for grub; only used for legacy (bios) boot mode
        gpuType = "nvidia"; # amd, intel or nvidia; only makes some slight mods for amd at the moment
      };

      userSettings = rec {
        username = "falcon";
        name = "Falcon";
        dotfilesDir = "~/.dotfiles";
        theme = "ayu-dark";
        wm = "qtile"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
        wmType = if (wm == "hyprland") then "wayland" else "x11";
        browser = "firefox"; # Default browser; must select one from ./user/app/browser/
        term = "kitty";
        font = "DejaVu Sans Mono";
        fontPkg = pkgs.dejavu_fonts;
        editor = "helix";
        # EDITOR and TERM session variables must be set in home.nix or other module
      };

    in
    {
      nixpkgs.overlays = [
        (self: super: {
          hie-nix = import (builtins.fetchGit { url = "https://github.com/infinisil/hie-nix"; });
        })
      ];
      homeConfigurations = {
        falcon = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix") # load home.nix from selected PROFILE
          ];
          extraSpecialArgs = {
            # pass config variables from above
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
            inherit pkgs-nwg-dock-hyprland;
            inherit pkgs-haskell-ormolu;
          };
        };
      };
      nixosConfigurations = {
        snowfire = lib.nixosSystem {
          inherit system;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
            inputs.lix-module.nixosModules.default
          ]; # load configuration.nix from selected PROFILE
          specialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };

    };
}

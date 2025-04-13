{
  description = "User flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    systems.url = "github:nix-systems/default-linux";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
    ormolu.url = "github:tweag/ormolu";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/hyprland-plugins.git";
      inputs.hyprland.follows = "hyprland";
    };
    hyprlock = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/hyprlock.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nwg-dock-hyprland-pin-nixpkgs.url = "nixpkgs/2098d845d76f8a21ae4fe12ed7c7df49098d3f15";
    xmonad-contexts = {
      url = "github:Procrat/xmonad-contexts";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, flake-utils, ... }:
    let
      lib = nixpkgs.lib;
      allSystemsOutputs = flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          constants = import ./constants.nix { inherit pkgs; };
          pkgs-nwg-dock-hyprland = import inputs.nwg-dock-hyprland-pin-nixpkgs { system = system; };
          pkgs-haskell-ormolu = inputs.ormolu.packages.${system}.default;

          homeConfigurations = lib.listToAttrs (
            map
              (machine: {
                name = "${machine.hostname}-${machine.profile}-${system}";
                value = home-manager.lib.homeManagerConfiguration {
                  inherit pkgs;
                  modules = [
                    (./. + "/profiles" + ("/" + machine.profile) + "/home.nix")
                  ];
                  extraSpecialArgs = {
                    systemSettings = constants.baseSystemSettings // {
                      hostName = machine.hostname;
                      profile = machine.profile;
                      system = system;
                    };
                    userSettings = constants.userSettings;
                    inherit inputs;
                    inherit pkgs-nwg-dock-hyprland;
                    inherit pkgs-haskell-ormolu;
                  };
                };
              })
              constants.machines
          );
          nixosConfigurations = lib.listToAttrs (
            map
              (machine: {
                name = "${machine.hostname}-${machine.profile}-${system}";
                value = lib.nixosSystem {
                  system = system;
                  modules = [
                    (./. + "/profiles" + ("/" + machine.profile) + "/configuration.nix")
                    inputs.lix-module.nixosModules.default
                  ];
                  specialArgs = {
                    systemSettings = constants.baseSystemSettings // {
                      hostName = machine.hostname;
                      profile = machine.profile;
                      system = system;
                    };
                    userSettings = constants.userSettings;
                    inherit inputs;
                    inherit constants;
                  };
                };
              })
              constants.machines
          );
        in
        {
          inherit homeConfigurations nixosConfigurations;
        }
      );
    in
    {
      homeConfigurations = lib.foldl' lib.attrsets.unionOfDisjoint { }
        (builtins.attrValues allSystemsOutputs.homeConfigurations);
      nixosConfigurations = lib.foldl' lib.attrsets.unionOfDisjoint { }
        (builtins.attrValues allSystemsOutputs.nixosConfigurations);
    };
}

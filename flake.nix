{
  description = "User flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
    # ormolu.url = "github:tweag/ormolu";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blocklist-hosts = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    devenv = {
      url = "github:cachix/devenv";
      # inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
    xmonad-contexts = {
      url = "github:Procrat/xmonad-contexts";
      flake = false;
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
  outputs =
    inputs@{ self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , flake-utils
    , ...
    }:
    let
      lib = nixpkgs.lib;
      allSystemsOutputs = flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          constants = import ./constants.nix { inherit pkgs; };
          # pkgs-haskell-ormolu = inputs.ormolu.packages.${system}.default;
          pkgs-devenv = inputs.devenv.packages.${system}.default;
          homeConfigurations = lib.listToAttrs (
            map
              (machine: {
                name = "${machine.hostname}-${machine.profile}-${system}";
                value = home-manager.lib.homeManagerConfiguration {
                  inherit pkgs;
                  modules = [
                    (./. + "/profiles" + ("/" + machine.profile) + "/home.nix")
                    inputs.nixvim.homeModules.nixvim
                  ];
                  extraSpecialArgs = {
                    systemSettings = constants.baseSystemSettings // {
                      hostName = machine.hostname;
                      profile = machine.profile;
                      system = system;
                    };
                    userSettings = constants.userSettings;
                    inherit inputs;
                    # inherit pkgs-haskell-ormolu;
                    inherit pkgs-devenv;
                    inherit pkgs-unstable;
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
                    # inputs.lix-module.nixosModules.default
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
                    inherit pkgs-unstable;
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
      homeConfigurations = lib.foldl' lib.attrsets.unionOfDisjoint { } (
        builtins.attrValues allSystemsOutputs.homeConfigurations
      );
      nixosConfigurations = lib.foldl' lib.attrsets.unionOfDisjoint { } (
        builtins.attrValues allSystemsOutputs.nixosConfigurations
      );
    };
}
# cgEJXpVKdcoisE7M

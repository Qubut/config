{ pkgs, config, inputs, ... }:
let
  toRgb = color: "rgb(${color})";
  toRgba = color: "rgba(${color}55)";
  baseColors = config.lib.stylix.colors;
in
{
  wayland.windowManager.hyprland = {
    # No plugins currently - hyprexpo is incompatible with Hyprland 0.54
    # To add plugins, uncomment and ensure they're compatible:
    # plugins = [
    #   inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
    #   inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprtrails
    # ];

    # Plugin configurations (only add if corresponding plugin is loaded)
    # settings.plugin = {
    #   hyprbars = { ... };
    # };
  };
}

{ lib, pkgs, config, inputs, system, ... }:
let
  inherit (lib) types mkEnableOption mkIf mkOpt;
  cfg = config.xeta.desktop.hyprland;
in {
  options.xeta.desktop.hyprland = {
    enable = mkEnableOption "Enable Hyprland.";
  };
  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = lib.xeta.getHyprlandPkg system;
      xwayland.enable = true;
      enableNvidiaPatches = true;
    };
  };
}

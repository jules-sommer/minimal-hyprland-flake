{ lib, pkgs, config, inputs, system, ... }:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt disabled;
  cfg = config.xeta.system.desktop.hyprland;
in {
  options.xeta.system.desktop.hyprland = {
    enable = mkEnableOption "Enable Hyprland.";
  };
  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager = {
        lightdm = disabled;
        gdm = disabled;
      };
      desktopManager.gnome = disabled;
      desktopManager.xterm = disabled;
    };

    programs.hyprland = {
      enable = true;
      package = lib.xeta.getHyprlandPkg system;
      xwayland.enable = true;
    };
  };
}

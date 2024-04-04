{ lib, pkgs, config, inputs, system, ... }:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt disabled enabled;
  cfg = config.xeta.system.desktop.hyprland;
in {
  options.xeta.system.desktop.hyprland = {
    enable = mkEnableOption "Enable Hyprland.";
  };
  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [ pyprland ];
    services.xserver = {
      enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 30;
      autorun = true;

      displayManager = {
        sddm = disabled;
        lightdm = disabled;
        gdm = disabled;
      };
      desktopManager = {
        gnome = disabled;
        xterm = disabled;
        xfce = disabled;
        plasma5 = disabled;
      };
    };

    programs.hyprland = {
      enable = true;
      package = lib.xeta.getHyprlandPkg system;
      xwayland.enable = true;
    };
  };
}

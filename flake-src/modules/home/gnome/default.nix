{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types mkEnableOption mkIf;
  cfg = config.xeta.gnome;
in
{
  options.xeta.gnome = {
    enable = mkEnableOption "Enable gnome GUI utils.";
  };
  config = mkIf cfg.enable {

    home = {
      packages = with pkgs; [
        gnome.gnome-disk-utility
        gnome.gnome-calculator
        gnome.gnome-logs
        gnome.gnome-panel
        gnome.file-roller
        gnome.gnome-weather
        gnome.gnome-nettool
        gnome.gnome-applets
        gnome.gnome-calendar
        gnome.gnome-screenshot
      ];
    };
  };
}

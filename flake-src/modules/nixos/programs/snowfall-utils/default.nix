{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.xeta.programs.snowfall-utils;
in
{
  options.xeta.programs.snowfall-utils = {
    enable = mkEnableOption "Enable Snowfall system packages";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      snowfallorg.drift
      snowfallorg.flake
      snowfallorg.thaw
    ];
  };
}

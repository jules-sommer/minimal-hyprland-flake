{ lib, pkgs, config, inputs, system, ... }:
let
  inherit (lib) types mkEnableOption mkIf mkOpt;
  cfg = config.xeta.system.services.filesystem;
in {
  options.xeta.system.services.filesystem = {
    enable = mkEnableOption "Enable filesystem services";
  };

  config = mkIf cfg.enable {
    services.tumbler.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;
    programs.thunar.enable = true;
  };
}

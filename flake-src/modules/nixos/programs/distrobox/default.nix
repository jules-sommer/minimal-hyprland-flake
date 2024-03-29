{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.xeta.system.programs.distrobox;
in {
  options.xeta.system.programs.distrobox = {
    enable = mkEnableOption "Enable distrobox";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ distrobox boxbuddy ];
  };
}

{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.jules) enabled;

  cfg = config.xeta.system.graphics.electron_support;
in {
  options.xeta.system.graphics.electron_support = {
    enable = mkEnableOption "Enable electron support";
  };

  config = mkIf cfg.enable {
    snowfallorg.user.xeta.home.config = {
      xdg.configFile."electron-flags.conf".source = ./electron-flags.conf;
    };
    environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };
  };
}

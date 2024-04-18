{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.development.go;
in
{
  options.xeta.development.go = {
    enable = mkEnableOption "Enable Go toolchain..";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      go
      gopls
    ];
  };
}

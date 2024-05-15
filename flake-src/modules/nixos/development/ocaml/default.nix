{ lib
, pkgs
, config
, ...
}:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.development.ocaml;
in
{
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ocaml
    ];
  };
}

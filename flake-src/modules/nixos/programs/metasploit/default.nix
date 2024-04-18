{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    types
    mkOption
    ;
  inherit (lib.xeta) enabled mkOpt mkListOf;
  cfg = config.xeta.programs.metasploit;
in
{
  options.xeta.programs.metasploit = {
    enable = mkOpt types.bool "Enable Metasploit" false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      metasploit
      armitage
    ];
  };
}

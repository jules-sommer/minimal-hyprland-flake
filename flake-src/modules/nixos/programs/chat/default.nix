{
  lib,
  pkgs,
  config,
  inputs,
  system,
  ...
}:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt enabled;
  cfg = config.xeta.programs.chat;
in
{
  options.xeta.programs.chat = {
    enable = mkEnableOption "Enable chat programs.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      webcord-vencord
      session-desktop
      signal-desktop
      signal-export
      signal-cli
      signald
      signaldctl
      signalbackup-tools
    ];
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.programs.rustdesk;
in
{
  options.xeta.programs.rustdesk = {
    enable = mkEnableOption "Enable RustDesk";
    relayIP = mkOpt (types.str) "" "Relay IP to use for RustDesk.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rustdesk
      rustdesk-server
    ];
    services.rustdesk-server = {
      enable = true;
      openFirewall = true;
      relayIP = cfg.relayIP;
      package = pkgs.rustdesk-server;
    };
  };
}

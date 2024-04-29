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
  cfg = config.xeta.security.tor;
in
{
  options.xeta.security.tor = {
    enable = mkEnableOption "Enable Tor browser and daemon.";
    settings = {
      proxychains = mkOpt (types.bool) true "Enable proxychains-ng.";
      torsocks = mkOpt (types.bool) true "Enable torsocks.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [ ];
    environment.systemPackages = with pkgs; [
      tor-browser
      libsForQt5.kleopatra
    ];

    programs.proxychains = mkIf cfg.settings.proxychains {
      enable = true;
      package = pkgs.proxychains-ng;
    };

    services.tor = {
      enable = true;
      client = enabled;
      settings = {
        ControlPort = [ { port = 9051; } ];
      };
      torsocks = mkIf cfg.settings.torsocks {
        enable = true;
        server = "127.0.0.1:9050";
        fasterServer = "127.0.0.1:9063";
      };
    };
  };
}

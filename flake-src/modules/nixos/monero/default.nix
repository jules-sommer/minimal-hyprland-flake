{
  lib,
  pkgs,
  config,
  inputs,
  system,
  ...
}:
let
  inherit (lib)
    types
    mkEnableOption
    mkIf
    mkMerge
    ;
  inherit (lib.xeta) mkOpt enabled;
  cfg = config.xeta.crypto;
in
{
  options.xeta.crypto = {
    enable = mkEnableOption "Enable crypto configuration";
    monero = {
      enable = mkEnableOption "Enable Monero configuration, by default just daemon but mining can be enabled";
      mining = {
        enable = mkEnableOption "Enable Monero mining";
        threads = mkOpt (types.int) 0 "Number of threads to use for mining";
        limitBandwidth = mkOpt (types.int) (-1) "Limit bandwidth usage for mining, ratelimit in KB/s";
        address = mkOpt (types.nullOr types.str) null "Monero wallet address to send mining rewards to.";
      };
    };
    bitcoin = {
      enable = mkEnableOption "Enable Bitcoin configuration";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      # {
      #   assertion =
      #     ((cfg.enable && cfg.mining.enable) && (cfg.mining.address != null));
      #   message = "Monero mining requires address to be set";
      # }
      # {
      #   assertion = (mkIf (cfg.mining.enable) (cfg.mining.threads >= 0));
      #   message =
      #     "Monero mining threads must be 0 (adaptive) or a positive number, but I am really intrigued by how you wound up with negative CPU threads!";
      # }
      # {
      #   assertion =
      #     (mkIf (cfg.mining.enable) (cfg.mining.limitBandwidth >= -1));
      #   message =
      #     "Monero mining bandwidth limit must be a positive number or -1 for unlimited bandwidth.";
      # }
    ];

    environment.systemPackages =
      with pkgs;
      mkMerge [
        (mkIf cfg.bitcoin.enable [
          electrum
          electrum-ltc
        ])
        (mkIf cfg.monero.enable [
          monero-cli
          monero-gui
        ])
      ];

    services.monero = mkIf cfg.monero.enable {
      enable = true; # cfg.daemon.enable;
      mining = mkIf cfg.monero.mining.enable {
        enable = true;
        inherit (cfg.monero.mining) threads address;
      };
      limits = mkIf (cfg.monero.mining.limitBandwidth != null) {
        download = cfg.monero.mining.limitBandwidth;
        upload = cfg.monero.mining.limitBandwidth;
      };
    };
  };
}

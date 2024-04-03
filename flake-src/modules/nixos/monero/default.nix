{ lib, pkgs, config, inputs, system, ... }:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt enabled;
  cfg = config.xeta.crypto.monero;
in {
  options.xeta.crypto = {
    monero = {
      enable = mkEnableOption
        "Enable Monero configuration, by default just daemon but mining can be enabled";
      mining = {
        enable = mkEnableOption "Enable Monero mining";
        threads = mkOpt (types.nullOr types.int) null
          "Number of threads to use for mining";
        limitBandwidth = mkOpt (types.nullOr types.int) null
          "Limit bandwidth usage for mining, ratelimit in KB/s";
        address = mkOpt (types.nullOr types.string) null
          "Monero wallet address to send mining rewards to.";
      };
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

    environment.systemPackages = with pkgs; [ monero-cli monero-gui ];

    services.monero = {
      enable = true; # cfg.daemon.enable;
      mining = mkIf cfg.mining.enable {
        enable = true;
        inherit (cfg.mining) threads address;
      };
      limits = mkIf (cfg.mining.limitBandwidth != null) {
        download = cfg.mining.limitBandwidth;
        upload = cfg.mining.limitBandwidth;
      };
    };
  };
}


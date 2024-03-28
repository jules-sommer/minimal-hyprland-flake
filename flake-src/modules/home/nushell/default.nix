{ lib, config, pkgs, ... }:
let
  inherit (lib) types;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.home.nushell;
in {
  options.xeta.home.nushell = { enable = lib.mkEnableOption "Enable nushell"; };

  config = lib.mkIf cfg.enable {
    programs = {
      nushell = {
        configFile.source = ./conf/config.nu;
        envFile.source = ./conf/env.nu;
        loginFile.source = ./conf/login.nu;
        environmentVariables = {
          # Add personal environment variables here
        };
        shellAliases = {
          # Add personal shell aliases here
        };
      };
    };
  };
}

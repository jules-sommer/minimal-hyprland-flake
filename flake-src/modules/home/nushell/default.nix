{ lib, config, pkgs, ... }:
let
  inherit (lib) types;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.nushell;
  home = config.home.homeDirectory;
in {
  options.xeta.nushell = { enable = lib.mkEnableOption "Enable nushell"; };

  config = lib.mkIf cfg.enable {
    # home.file.${home + "/070_dotfiles/nushell/autoconf.nix"}.source =
    # (builtins.fromJSON (builtins.readFile ./config.json));
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

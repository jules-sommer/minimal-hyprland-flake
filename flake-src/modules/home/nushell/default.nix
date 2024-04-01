{ lib, config, pkgs, ... }:
let
  inherit (lib) types;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.nushell;

  home = config.home.homeDirectory;

  # formatOption = name: value:
  #   if builtins.isBool value then
  #     "${name}: ${builtins.toString value} # true or false"
  #   else if builtins.isInt value || builtins.isFloat value then
  #     "${name}: ${builtins.toString value}"
  #   else if builtins.isString value then
  #     "${name}: ${value}"
  #   else if builtins.isList value then
  #     "${name}: [${
  #       builtins.concatStringsSep ", "
  #       (builtins.map (v: builtins.toString v) value)
  #     }]"
  #   else if builtins.isAttrs value then ''
  #     ${name}: {
  #     ${builtins.concatStringsSep "\n"
  #     (lib.attrsets.mapAttrsToList formatOption value)}
  #     }'' else
  #     "";

  # getFormattedConfig = config:
  #   builtins.concatStringsSep "\n"
  #   (lib.attrsets.mapAttrsToList formatOption config);

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

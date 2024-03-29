{ lib, pkgs, config, inputs, system, ... }:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt getMeta;

  cfg = config.xeta.system;
  # assert lib.assertMsg (cfg.user.username != null)
  #   "You must set a username to use this flake @ config.xeta.system.user.username";
  # assert lib.assertMsg (cfg.user.fullname != null)
  #   "You must set a full name to use this flake @ config.xeta.system.user.fullname";
  # assert lib.assertMsg (cfg.user.home != null)
  #   "You must set a home directory to use this flake @ config.xeta.system.user.home";
  # assert lib.assertMsg (cfg.hostname != null)
  #   "You must set a hostname to use this flake @ config.xeta.system.hostname";

in {
  options.xeta.system = {
    user = {
      username = mkOpt (types.nullOr types.str) null "The username of the user";
      fullname =
        mkOpt (types.nullOr types.str) null "The full name of the user";
      home =
        mkOpt (types.nullOr (types.either types.path types.str)) null "The home directory of the user";
    };
    hostname = mkOpt (types.nullOr types.str) null "The hostname of the system";
  };

  config = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${cfg.user.username} = {
      isNormalUser = true;
      homeMode = "755";
      useDefaultShell = true;
      description = cfg.user.fullname;
      extraGroups = [ "networkmanager" "wheel" ];
    };
  };
}

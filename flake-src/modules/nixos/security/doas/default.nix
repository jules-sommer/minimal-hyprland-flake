{ options, config, pkgs, lib, ... }:

with lib;
with lib.xeta;
let cfg = config.xeta.security.doas;
in {
  options.xeta.security.doas = {
    enable = mkBoolOpt false "Whether or not to replace sudo with doas.";
  };

  config = mkIf cfg.enable {
    # Disable sudo
    security.sudo.enable = false;

    # Enable and configure `doas`.
    security.doas = {
      enable = true;
      extraRules = [{
        users = [ config.xeta.system.user.username ];
        noPass = true;
        keepEnv = true;
      }];
    };

    # Add an alias to the shell for backward-compat and convenience.
    environment.shellAliases = { sudo = "doas"; };
  };
}

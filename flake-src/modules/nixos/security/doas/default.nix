{ options
, config
, pkgs
, lib
, ...
}:

with lib;
with lib.xeta;
let
  cfg = config.xeta.security.doas;
in
{
  options.xeta.security.doas = {
    enable = mkBoolOpt false "Whether or not to replace sudo with doas.";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.xeta.system.user.username != null || config.xeta.system.user.username != "";
        message = "You must set a username to use this flake @ config.xeta.system.user.username";
      }
      {
        assertion =
          (cfg.enable == true && config.security.doas.enable == true)
          || (cfg.enable == false && config.security.doas.enable == false);
        message = "Error: doas is misconfigured, the flake option is out of sync with the system configuration.";
      }
    ];

    environment.systemPackages = with pkgs; [
      doas
    ];

    # Disable sudo
    security.sudo.enable = false;

    # Enable and configure `doas`.
    security.doas = {
      enable = true;
      extraRules = [
        {
          users = [ config.xeta.system.user.username ];
          noPass = true;
          keepEnv = true;
        }
      ];
    };

    # Add an alias to the shell for backward-compat and convenience.
    environment.shellAliases = {
      sudo = "doas";
    };
  };
}

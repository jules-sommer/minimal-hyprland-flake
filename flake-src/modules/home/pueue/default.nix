{ lib, config, pkgs, ... }:
let
  inherit (lib) types;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.services.pueued;
in {
  options.xeta.services.pueued = {
    enable = lib.mkEnableOption
      "Enable pueue daemon for background tasks and CLI scheduler/manager.";
    default_parallel_tasks =
      mkOpt (types.int) 6 "Number of parallel tasks to run by default.";
  };

  config = lib.mkIf cfg.enable {
    services = {
      pueue = {
        enable = true;
        settings = {
          daemon = { default_parallel_tasks = cfg.default_parallel_tasks; };
        };
      };
    };
  };
}

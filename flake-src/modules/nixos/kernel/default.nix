{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.kernel;
in
{
  options.xeta.kernel = {
    enable = mkEnableOption "Enable kernel configuration";
    v4l2loopback = mkOpt (types.nullOr types.bool) true "Enable v4l2loopback kernel modules.";
    package = mkOpt (types.nullOr (
      types.enum (
        with pkgs;
        [
          linuxPackages_latest
          linuxPackages_latest-libre
          linuxPackages_latest_hardened
          linuxPackages_latest_xen_dom0
          linuxPackages_zen
        ]
      )
    )) null "The kernel package to use";
  };

  config = mkIf (cfg.enable) {
    assertions = [
      {
        # if enabled, package must be set
        assertion = cfg.package != null;
        message = "[xeta.nixos.kernel] config.xeta.kernel.package must be set if config.xeta.kernel.enable is true";
      }
      {
        # if package is set, it must be a single valid kernel package
        assertion =
          cfg.package == pkgs.linuxPackages_latest
          || cfg.package == pkgs.linuxPackages_latest-libre
          || cfg.package == pkgs.linuxPackages_latest_hardened
          || cfg.package == pkgs.linuxPackages_latest_xen_dom0
          || cfg.package == pkgs.linuxPackages_zen;
        message = "[xeta.nixos.kernel] config.xeta.kernel.package must be set to a single valid kernel package";
      }
    ];

    # boot.kernelModules = [ "v4l2loopback" ];
    # boot.extraModulePackages = [ pkgs.linuxPackages_latest.v4l2loopback ];
    # boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}

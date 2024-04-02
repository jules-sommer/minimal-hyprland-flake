{ lib, inputs, config, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf types mkMerge;
  inherit (lib.lists) optional;
  inherit (lib.xeta) enabled mkOpt mkListOf mkBoolOpt;

  cfg = config.xeta.system.programs.dconf;
  username = config.xeta.system.user.username;
in {
  options.xeta.system.programs.dconf = {
    enable = mkEnableOption "Enable dconf settings";
  };

  config = mkIf cfg.enable {
    programs = {
      xfconf = enabled;
      dconf = enabled;
    };
    snowfallorg.user.${username}.home.config = {
      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      };
    };
  };
}

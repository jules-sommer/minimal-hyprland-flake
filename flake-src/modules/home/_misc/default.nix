{ lib, config, pkgs, ... }:
let
  inherit (lib) types mkEnableOption recursiveUpdate;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.misc;

in {
  options.xeta.home =
    mkOpt (types.nullOr types.str) null "The home directory of the user";
  options.xeta.misc = { enable = mkEnableOption "Enable misc packages."; };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      localsend
      rsync
      grsync
      nb
      socat
      moreutils
      dt
      fzf
      dust
    ];
  };
}

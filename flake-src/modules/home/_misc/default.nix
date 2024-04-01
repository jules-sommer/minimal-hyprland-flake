{ lib, config, pkgs, ... }:
let
  inherit (lib) types mkEnableOption recursiveUpdate;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.misc;

in {
  options.xeta.misc = { enable = mkEnableOption "Enable misc packages."; };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      localsend
      rsync
      grsync
      nb
      moreutils
      dt
      fzf
      dust
    ];
  };
}

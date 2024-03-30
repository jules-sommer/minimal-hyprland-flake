{ lib, config, pkgs, ... }:
let
  inherit (lib) types mkEnableOption recursiveUpdate;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.home.misc;

in {
  options.xeta.home.misc = { enable = mkEnableOption "Enable misc packages."; };

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

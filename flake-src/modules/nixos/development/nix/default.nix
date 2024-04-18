{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.development.go;
in
{
  options.xeta.development.nix = {
    enable = mkEnableOption "Enable Nix toolchain..";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nvd
      nix-du
      nixfmt-rfc-style
      nh
      nix-output-monitor
      nix-prefetch-git
    ];
  };
}

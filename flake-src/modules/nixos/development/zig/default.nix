{ lib, pkgs, config, inputs, system, ... }:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.system.development.zig;
in {
  options.xeta.system.development.zig = {
    enable = mkEnableOption "Enable Zig support";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zig
      zls
      vscode-extensions.ziglang.vscode-zig
    ];
  };
}

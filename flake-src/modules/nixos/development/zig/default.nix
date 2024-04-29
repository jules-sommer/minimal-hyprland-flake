{
  lib,
  pkgs,
  config,
  inputs,
  system,
  ...
}:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.development.zig;
in
{
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zig
      zls
      vscode-extensions.ziglang.vscode-zig
    ];
  };
}

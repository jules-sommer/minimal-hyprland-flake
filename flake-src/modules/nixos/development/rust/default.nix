{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.development.rust;
in
{
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (pkgs.fenix.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])
      pkgs.vscode-extensions.rust-lang.rust-analyzer-nightly
      pkgs.rust-analyzer-nightly
    ];
  };
}

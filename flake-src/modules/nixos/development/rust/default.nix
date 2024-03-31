{ lib, pkgs, config, ... }:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.system.development.rust;
in {
  options.xeta.system.development.rust = {
    enable = mkEnableOption "Enable Rust toolchain via/Fenix overlay.";
    profile = mkOpt (types.enum [ "default" "minimal" "complete" ]) "complete"
      "Profile of Rust toolchain to use, must be one of: default, minimal, complete.";
  };

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

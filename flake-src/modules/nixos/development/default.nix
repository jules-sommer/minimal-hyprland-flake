{ lib
, pkgs
, config
, inputs
, system
, ...
}:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.langs;
  anyLangEnabled = lib.any
    (
      lang:
      lib.attrByPath [
        lang
        "enable"
      ]
        false
        cfg
    )
    (lib.attrNames cfg);
in
{
  options.xeta.development = {
    rust = {
      enable = mkEnableOption "Enable Rust toolchain via/Fenix overlay.";
      profile = mkOpt
        (types.enum [
          "default"
          "minimal"
          "complete"
        ]) "complete" "Profile of Rust toolchain to use, must be one of: default, minimal, complete.";
    };
    ocaml = {
      enable = mkEnableOption "Enable OCaml support";
    };
    zig = {
      enable = mkEnableOption "Enable Zig support";
    };
    nix = {
      enable = mkEnableOption "Enable Nix toolchain..";
    };
    go = {
      enable = mkEnableOption "Enable Go configuration.";
    };
    typescript = {
      enable = mkEnableOption "Enable TypeScript configuration.";
      runtimes =
        mkOpt
          # option type
          (types.listOf types.enum [
            "nodejs"
            "deno"
          ])
          # default
          [
            "nodejs"
            "deno"
          ]
          # description
          "Runtimes to use for TypeScript.";
    };
    c = {
      enable = mkEnableOption "Enable C configuration.";
    };
  };
  config = {
    environment.systemPackages = with pkgs; [
      wl-clipboard
      wl-clip-persist
      git
      lazygit
      gh
      gitoxide
      ripgrep
      fd
      bat
      github-copilot-cli
      helix
      deploy-rs
      nixfmt
      nix-index
      nix-prefetch-git
      nix-output-monitor
      flake-checker
      starship
      zoxide
      broot
      nushell
      busybox
      jujutsu
      nil
      pzip
      jql
      jq-lsp
      apx
    ];
  };
}

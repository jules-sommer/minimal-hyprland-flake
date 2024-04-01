{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.system.programs.misc;
in {
  options.xeta.system.programs.misc = {
    enable = mkEnableOption "Enable RustDesk";
    relayIP = mkOpt (types.str) "" "Relay IP to use for RustDesk.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      jujutsu
      git
      lazygit
      starship
      helvum
      rnr
      btop
      gh
      nil
      zoxide
      broot
      ripgrep
      fd
      bat
      github-copilot-cli
      gitoxide
      helix
      pzip
      nixfmt
      nushell
      alacritty
      ntfs3g
      fuseiso
      kitty

      xz
      jq
      fd
      jql
      jq-lsp
      zoxide
      apx

      obsidian
      grim
      grimblast
      slurp

      networkmanagerapplet
      polkit_gnome

      lcsync
      librespot
      libresprite
      # librecad
      # librepcb

      deploy-rs
      nixfmt
      nix-index
      nix-prefetch-git
      nix-output-monitor
      flake-checker
    ];
  };
}

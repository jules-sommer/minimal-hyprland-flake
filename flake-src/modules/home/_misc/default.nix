{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types mkEnableOption recursiveUpdate;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.misc;
in
{
  options.xeta.home = mkOpt (types.nullOr types.str) null "The home directory of the user";
  options.xeta.misc = {
    enable = mkEnableOption "Enable misc packages.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      localsend
      rsync
      grsync
      nb
      tsukae
      wtype

      obs-studio
      obs-cli

      inkscape-with-extensions
      gimp
      qbittorrent
      transmission
      socat
      moreutils
      dt
      fzf
      dust
      du-dust
      tree
      dirdiff

      # System Utilities & Compatibility
      alacritty
      kitty
      ntfs3g
      fuseiso
      xz
      jq
      fd
      nufmt
      obsidian
      grim
      grimblast
      slurp
      lcsync
      librespot
      libresprite
      librepcb # broken due to 'freeimage-unstable-2021-11-01', see /overlays/librepcb-stable/default.nix

      gtk3
      gtk3.dev
      gtk4
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

      # Desktop & GUI Software
      chromium
    ];
  };
}

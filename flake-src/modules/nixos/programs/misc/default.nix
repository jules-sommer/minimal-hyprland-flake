{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.programs.misc;
in
{
  options.xeta.programs.misc = {
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
      meld
      tree
      helix
      pzip
      nixfmt-rfc-style
      nushell
      alacritty
      ntfs3g
      fuseiso
      kitty

      wget curl git cmatrix lolcat neofetch htop btop libvirt
      polkit_gnome lm_sensors unzip unrar libnotify eza
      v4l-utils ydotool wl-clipboard socat cowsay lsd lshw
      pkg-config meson hugo gnumake ninja go nodejs symbola
      noto-fonts-color-emoji material-icons brightnessctl
      toybox virt-viewer swappy ripgrep appimage-run 
      networkmanagerapplet yad playerctl nh

      firefox
      geckodriver
      chromedriver

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
      chatgpt-cli
      psst
      spot
      spotifyd

      deploy-rs
      nix-index
      nix-prefetch-git
      nix-output-monitor
      flake-checker
    ];
  };
}

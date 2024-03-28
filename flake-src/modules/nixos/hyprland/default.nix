{ lib, pkgs, config, inputs, system, ... }:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt disabled;
  cfg = config.xeta.desktop.hyprland;
in {
  options.xeta.desktop.hyprland = {
    enable = mkEnableOption "Enable Hyprland.";
  };
  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager = {
        lightdm = disabled;
        gdm = disabled;
      };
      desktopManager.gnome = disabled;
      desktopManager.xterm= disabled;
    };

    environment.systemPackages = with pkgs; [
      greetd
      greetd.tuigreet
      swaybg
      wl-clipboard
      swaynotificationcenter
      font-awesome
      polkit_gnome
      slurp
      xclip
      grim
      grimblast
    ];

    services.greetd = {
      enable = true;
      package = pkgs.greetd.greetd;
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
        };
      };
    };

    programs.hyprland = {
      enable = true;
      package = lib.xeta.getHyprlandPkg system;
      xwayland.enable = true;
      enableNvidiaPatches = true;
    };
  };
}

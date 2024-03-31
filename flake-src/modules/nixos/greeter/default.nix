{ lib, pkgs, config, inputs, system, ... }:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt disabled;
  cfg = config.xeta.system.desktop.greeter;
in {
  options.xeta.system.desktop.greeter = {
    enable = mkEnableOption "Enable greetd greeter.";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      greetd.greetd
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
      settings = {
        default_session = {
          user = "greeter";
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        };
      };
    };
  };
}


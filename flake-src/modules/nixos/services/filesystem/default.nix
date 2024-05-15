{
  lib,
  pkgs,
  config,
  inputs,
  system,
  ...
}:
let
  inherit (lib)
    types
    mkEnableOption
    mkIf
    mkOpt
    ;
  cfg = config.xeta.services.filesystem;
in
{
  options.xeta.services.filesystem = {
    enable = mkEnableOption "Enable filesystem services";
  };

  config = mkIf cfg.enable {
    services.tumbler.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
        thunar-media-tags-plugin
      ];
    };

    environment.systemPackages = with pkgs; [
      gnome.nautilus
      gnome.sushi
      gnome.totem
    ];

    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "alacritty";
    };
  };
}

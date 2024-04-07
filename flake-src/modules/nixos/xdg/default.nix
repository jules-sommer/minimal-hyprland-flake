{ lib, config, pkgs, ... }:
let
  inherit (lib) types mkIf;
  inherit (lib.xeta) mkOpt;
  isHyprland = config.xeta.system.desktop.hyprland.enable;
  username = config.xeta.system.user.username;
  home = config.xeta.system.user.home;
  dotfiles = config.xeta.system.user.dotfiles;

  cfg = config.xeta.system.portals;

  portals = with pkgs; [
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    xdg-desktop-portal-hyprland
  ];
in {
  options.xeta.system.portals = {
    enable = lib.mkEnableOption
      "Enable various XDG portals for desktop environment app compatibility.";
  };

  config = lib.mkIf cfg.enable {
    snowfallorg.user.${username}.home.config = {
      programs.nushell.environmentVariables = {
        XDG_SESSION_TYPE = "wayland";
        XDG_CONFIG_HOME = dotfiles;
        XDG_CURRENT_DESKTOP = "GNOME";
        QT_QPA_PLATFORM = "wayland;xcb";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
      };

      xdg = {
        configHome = dotfiles;
        userDirs = {
          enable = true;
          createDirectories = true;
          documents = "${home}/010_documents";
          download = "${home}/040_downloads";
          music = "${home}/060_media/030_music";
          videos = "${home}/060_media/020_videos";
          pictures = "${home}/060_media/020_videos";
          templates = "${home}/110_misc/030_templates";
          publicShare = "${home}/110_misc/020_public";
          desktop = "${home}/110_misc/040_desktop";
        };
      };
    };

    services.dbus.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal ];
      configPackages = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
        xdg-desktop-portal
      ];
    };
  };
}


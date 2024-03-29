{ lib, config, pkgs, ... }:
let
  inherit (lib) types mkIf;
  inherit (lib.xeta) mkOpt;
  isHyprland = config.xeta.system.desktop.hyprland;
  cfg = config.xeta.system.portals;
  username = config.xeta.system.user.username;
  home = config.xeta.system.user.home;
  dotfiles = config.xeta.system.user.dotfiles;
in {
  options.xeta.system.portals = {
    enable = lib.mkEnableOption
      "Enable various XDG portals for desktop environment app compatibility.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      lib.mkMerge ([
        [ xdg-utils xdg-desktop-portal xdg-desktop-portal-gtk ]
        (mkIf (isHyprland) [ xdg-desktop-portal-hyprland ])
      ]);

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
        userDirs = {
          enable = true;
          createDirectories = true;
        };
      };
    };

    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal ];
        configPackages = with pkgs;
          lib.mkMerge ([
            [ xdg-desktop-portal ]
            (mkIf isHyprland [ xdg-desktop-portal-hyprland ])
          ]);
      };
    };
  };
}


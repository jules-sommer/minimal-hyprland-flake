{
  lib,
  pkgs,
  config,
  inputs,
  system,
  ...
}:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.system.env;
  home = config.xeta.system.user.home;
  username = config.xeta.system.user.username;
  dotfiles = config.xeta.system.user.dotfiles;
in
{
  options.xeta.system.env = {
    enable = mkEnableOption "Enable common environment variables and session config.";
  };
  config =
    let
      variables = {
        NIXOS_OZONE_WL = "1";
        NIXPKGS_ALLOW_UNFREE = "1";

        # XDG specific env vars are often detected thru
        # portals, but it's good to set them explicitly
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "Hyprland";
        XDG_CONFIG_HOME = lib.mkDefault dotfiles;

        # Nvidia specific env vars
        # GBM_BACKEND = "nvidia-drm";
        # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        LIBVA_DRIVER_NAME = "radeonsi";
        GDK_BACKEND = "wayland,x11"; # GTK use wayland by default, fallback to x11
        CLUTTER_BACKEND = "wayland";
        SDL_VIDEODRIVER = "wayland";
        __GL_VRR_ALLOWED = "0";
        MOZ_ENABLE_WAYLAND = "1";

        POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        XCURSOR_SIZE = "24";
        XCURSOR_THEME = "Bibata-Modern-Ice";
        QT_QPA_PLATFORMTHEME = pkgs.lib.mkDefault "qt5ct";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        # NIX_PATH = "nixpkgs=${home}/.nix-defexpr/channels_root/nixos";
      };
    in
    mkIf cfg.enable {
      environment.variables = variables;
      snowfallorg.user.${username}.home.config = {
        programs.nushell.environmentVariables = variables;
      };
    };
}

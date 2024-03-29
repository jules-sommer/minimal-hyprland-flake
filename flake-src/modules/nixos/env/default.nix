{ lib, pkgs, config, inputs, system, ... }:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.system.env;
	home = config.xeta.system.user.home;
in {
  options.xeta.system.env = {
		enable = mkEnableOption "Enable common environment variables and session config.";
  };
  config = mkIf cfg.enable {
		environment.variables = {
			NIXOS_OZONE_WL = "1";
			NIXPKGS_ALLOW_UNFREE = "1";
			XDG_CONFIG_HOME = "${home}/_dev/.config";
			XDG_SESSION_TYPE = "wayland";
			GDK_BACKEND = "wayland";
			CLUTTER_BACKEND = "wayland";
			SDL_VIDEODRIVER = "wayland";
			POLKIT_BIN =
			"${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
			XCURSOR_SIZE = "24";
			XCURSOR_THEME = "Bibata-Modern-Ice";
			QT_QPA_PLATFORMTHEME = pkgs.lib.mkDefault "qt5ct";
			QT_QPA_PLATFORM = "wayland";
			QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
			QT_AUTO_SCREEN_SCALE_FACTOR = "1";
			MOZ_ENABLE_WAYLAND = "1";
			# NIX_PATH = "${home}/.nix-defexpr/channels_root/nixos";
		};
  };
}


{ lib, pkgs, config, inputs, system, ... }:
let
  inherit (lib) types mkEnableOption mkIf;
	inherit (lib.xeta) mkOpt enabled;
  cfg = config.xeta.system.services.polkit;
in {
  options.xeta.system.services.polkit= {
		enable = mkEnableOption "Enable polkit authentication agent.";
  };

  config = mkIf cfg.enable {
		systemd = {
			user.services.polkit-gnome-authentication-agent-1 = {
				description = "polkit-gnome-authentication-agent-1";
				wantedBy = ["graphical-session.target"]; 
				wants = ["graphical-session.target"]; 
				after = ["graphical-session.target"]; 
				serviceConfig = {
					Type = "simple";
					ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
					Restart = "on-failure";
					RestartSec = 1;
					TimeoutStopSec = 10; 
				};
			};
		};
		security.polkit = enabled;
		xdg.portal = {
			enable = true;
			extraPortals = with pkgs; [ xdg-desktop-portal ];
			configPackages = with pkgs; [ xdg-desktop-portal-hyprland xdg-desktop-portal ];
		};
		environment.variables = {
			POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
		};
  };
}

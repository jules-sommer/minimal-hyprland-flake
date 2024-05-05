{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf types mkEnableOption;
  inherit (lib.xeta) getTheme mkOpt;
  cfg = config.xeta.desktop.waybar;
  theme = getTheme (config.xeta.desktop.hyprland.theme);
in
{
  options.xeta.desktop.waybar = {
    enable = mkEnableOption "Enable waybar";
    package = mkOpt (types.nullOr types.package) pkgs.waybar;
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.lists.elem "hyprland/window" (
          (builtins.elemAt config.programs.waybar.settings 0).modules-left
        );
        message = "waybar.package must be set";
      }
    ];
    home.packages = [ pkgs.font-awesome ];
    programs.waybar = {
      enable = true;
      package = pkgs.waybar;
      settings = [
        {
          layer = "top";
          position = "top";
          height = 35;
          margin-top = 6;
          margin-left = 8;
          margin-right = 8;
          spacing = 8;
          reload-style-on-change = true;
          include = [ "~/.config/waybar/styles-extra.css" ];

          modules-left = [
            "custom/startmenu"
            "hyprland/window"
            "hyprland/workspaces"
            "cpu"
            "memory"
          ];

          modules-center = [ "clock" ];

          modules-right = [
            "custom/quit"
            "idle_inhibitor"
            "custom/notification"
            "battery"
            "tray"
            "pulseaudio"
          ];

          "hyprland/workspaces" = {
            format = "<sub>{icon} %s {name}</sub>\n{windows}";
            format-icons = {
              default = "%s";
              active = "";
              urgent = "";
            };
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
          };
          clock = {
            format = " {:%I:%M %p}";
            format-alt = "{:%a, %d. %b  %H:%M}";
            tooltip-format = ''
              <big>{%I:%M %p}</big>
              <tt><small>{calendar}</small></tt>
            '';
            tooltip = true;
          };
          "hyprland/window" = {
            max-length = 25;
            separate-outputs = false;
          };
          memory = {
            interval = 5;
            format = " {}%";
            tooltip = true;
          };
          cpu = {
            interval = 5;
            format = " {usage:2}%";
            tooltip = true;
          };
          disk = {
            format = "  {free} / {total}";
            tooltip = true;
            on-click = "hyprctl dispatch 'exec alacritty -e broot -hipsw'";
          };
          network = {
            format-icons = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            format-ethernet = ": {bandwidthDownOctets}";
            format-wifi = "{icon} {signalStrength}%";
            format-disconnected = "󰤮";
            tooltip = false;
            on-click = "nm-applet";
          };
          tray = {
            spacing = 12;
          };
          pulseaudio = {
            format = "{icon} {volume}% {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = " {volume}%";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [
                ""
                ""
                ""
              ];
            };
            on-click = "pavucontrol";
          };
          "custom/startmenu" = {
            tooltip = false;
            format = "";
            # exec = "rofi -show drun";
            on-click = "rofi -show drun";
          };
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
            tooltip = "true";
            tooltip-format = "Inhibit idle? {state}";
          };
          "custom/notification" = {
            tooltip = false;
            format = "{icon} {}";
            format-icons = {
              notification = "<span foreground='red'><sup></sup></span>";
              none = "";
              dnd-notification = "<span foreground='red'><sup></sup></span>";
              dnd-none = "";
              inhibited-notification = "<span foreground='red'><sup></sup></span>";
              inhibited-none = "";
              dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
              dnd-inhibited-none = "";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t";
            escape = true;
          };
          privacy = {
            icon-spacing = 4;
            icon-size = 18;
            transition-duration = 250;
            modules = [
              {
                "type" = "screenshare";
                "tooltip" = true;
                "tooltip-icon-size" = 24;
              }
              {
                "type" = "audio-out";
                "tooltip" = true;
                "tooltip-icon-size" = 24;
              }
              {
                "type" = "audio-in";
                "tooltip" = true;
                "tooltip-icon-size" = 24;
              }
            ];
          };
          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-plugged = "󱘖 {capacity}%";
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            on-click = "";
            tooltip = false;
          };
          "custom/quit" = {
            format = "";
            on-click = "";
          };
        }
      ];

      style = ''
        * {
          font-size: 14px;
          font-family: 'JetBrains Mono', Font Awesome;
              font-weight: 600;
        }

        span.hyprland-workspaces {
          font-size: 8px;
        }
        label.module {
          padding: 0 15px;
          box-shadow: inset 0 -3px;
        }
        box.module button:hover {
          box-shadow: inset 0 -3px #ffffff;
        }

        box.module {
          box-shadow: inset 0 -2.5px;
          border-radius: 8px;
          margin-top: 4px;
          margin-bottom: 4px;
          background-color: rgba(85,25,95,0.20);
        }
        window#waybar {
          border-radius: 10px;
          margin: 10px;
          padding: 5px;
          border: 2px solid rgba(231,113,252,0.8);
          background-color: rgba(85,25,95,0.40);
          color: #${theme.base0F};
        }
        #workspaces {
          background: black;
          padding: 4px;
          border-radius: 5px;
          border: 2px solid #${theme.base0F};
          font-style: normal;
          color: white;
        }
        #workspaces button {
          color: #${theme.base00};
          background-color: #${theme.base00};
          opacity: 1.0;
          transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
        }
        #workspaces button.active {
          color: #${theme.base00};
          background: #${theme.base04};
          min-width: 40px;
          transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
          opacity: 1.0;
        }
        #workspaces button:hover {
          color: #${theme.base02};
          background: #${theme.base04};
          opacity: 1.0;
        }
        tooltip {
          background: black;
          border: 1px solid rgba(255,255,255,0.2);
          border-radius: 5px;
        }
        tooltip label {
          color: white;
        }
        #window {
          color: #${theme.base05};
          background: #${theme.base00};        
          padding: 5px;
        }
        #memory {
          color: #${theme.base0F};
          background: #${theme.base00};        
          padding: 5px;
        }
        #clock {
          color: #${theme.base0B};
          background: #${theme.base00};        
          padding: 5px;
        }
        #idle_inhibitor {
          color: #${theme.base0A};
          background: #${theme.base00};        
          padding: 5px;
        }
        #cpu {
          color: #${theme.base07};
          background: #${theme.base00};        
          padding: 5px;
        }
        #disk {
          color: #${theme.base03};
          background: #${theme.base00};        
          padding: 5px;
        }
        #battery {
          color: #${theme.base08};
          background: #${theme.base00};        
          padding: 5px;
        }
        #network {
          color: #${theme.base09};
          background: #${theme.base00};        
          padding: 5px;
        }
        #tray {
          color: #${theme.base05};
          background: #${theme.base00};        
          padding: 5px;
        }
        #pulseaudio {
          color: #${theme.base0D};
          background: #${theme.base00};        
          padding: 5px;
        }
        #custom-notification {
          color: #${theme.base0C};
          background: #${theme.base00};        
          padding: 5px;
        }
        #custom-themeselector {
          color: #${theme.base0D};
          background: #${theme.base00};        
          padding: 5px;
        }
        #custom-startmenu {
          color: #${theme.base03};
          background: #${theme.base00};        
          padding: 5px;
        }
        #idle_inhibitor {
          color: #${theme.base09};
          background: #${theme.base00};        
          padding: 5px;
        }
      '';
    };
  };
}

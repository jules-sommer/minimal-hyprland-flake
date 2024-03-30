{ pkgs, config, lib, inputs, ... }:
let
  inherit (lib.xeta) getTheme mkOpt;
  theme = getTheme (config.xeta.home.desktop.hyprland.theme);
in {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [{
      layer = "top";
      position = "top";

      modules-left =
        [ "custom/startmenu" "hyprland/window" "pulseaudio" "cpu" "memory" ];
      modules-center = [
        "network"
        "custom/themeselector"
        "pulseaudio"
        "cpu"
        "hyprland/workspaces"
        "memory"
        "disk"
        "clock"
      ];

      modules-right = [
        "custom/hyprbindings"
        "custom/exit"
        "idle_inhibitor"
        "custom/themeselector"
        "custom/notification"
        "battery"
        "clock"
        "tray"
      ];

      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          default = " ";
          active = " ";
          urgent = " ";
        };
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
      };
      "clock" = {
        format = "{: %I:%M %p}";
        tooltip = false;
      };
      "hyprland/window" = {
        max-length = 25;
        separate-outputs = false;
      };
      "memory" = {
        interval = 5;
        format = " {}%";
        tooltip = true;
      };
      "cpu" = {
        interval = 5;
        format = " {usage:2}%";
        tooltip = true;
      };
      "disk" = {
        format = "  {free} / {total}";
        tooltip = true;
        on-click = "hyprctl dispatch 'exec alacritty -e broot -hipsw'";
      };
      "network" = {
        format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
        format-ethernet = ": {bandwidthDownOctets}";
        format-wifi = "{icon} {signalStrength}%";
        format-disconnected = "󰤮";
        tooltip = false;
        on-click = "nm-applet";
      };
      "tray" = { spacing = 12; };
      "pulseaudio" = {
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
          default = [ "" "" "" ];
        };
        on-click = "pavucontrol";
      };
      "custom/themeselector" = {
        tooltip = false;
        format = "";
        # exec = "theme-selector";
        on-click = "theme-selector";
      };
      "custom/startmenu" = {
        tooltip = false;
        format = "";
        # exec = "rofi -show drun";
        on-click = "rofi -show drun";
      };
      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
        tooltip = "true";
      };
      "custom/notification" = {
        tooltip = false;
        format = "{icon} {}";
        format-icons = {
          notification = "<span foreground='red'><sup></sup></span>";
          none = "";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
          inhibited-notification =
            "<span foreground='red'><sup></sup></span>";
          inhibited-none = "";
          dnd-inhibited-notification =
            "<span foreground='red'><sup></sup></span>";
          dnd-inhibited-none = "";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t";
        escape = true;
      };
      "privacy" = {
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
      "battery" = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-plugged = "󱘖 {capacity}%";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        on-click = "";
        tooltip = false;
      };
    }];
    style = ''
      * {
        font-size: 16px;
        font-family: 'JetBrains Mono', Font Awesome, monospace;
            font-weight: 600;
      }
      window#waybar {
            margin: 5px;
            padding: 5px;
            border-radius: 15px;
            border: 2px solid #${theme.base0F};
            border-bottom: 1px solid rgba(26,27,38,0);
            background-color: rgba(26,27,38,0.64);
            color: #${theme.base0F};
      }
      #workspaces {
            background: linear-gradient(180deg, #${theme.base00}, #${theme.base01});
            margin: 5px;
            padding: 0px 1px;
            border-radius: 15px;
            border: 0px;
            font-style: normal;
            color: #${theme.base00};
      }
      #workspaces button {
            padding: 0px 5px;
            margin: 4px 3px;
            border-radius: 15px;
            border: 0px;
            color: #${theme.base00};
            background-color: #${theme.base00};
            opacity: 1.0;
            transition: all 0.3s ease-in-out;
      }
      #workspaces button.active {
            color: #${theme.base00};
            background: #${theme.base04};
            border-radius: 15px;
            min-width: 40px;
            transition: all 0.3s ease-in-out;
            opacity: 1.0;
      }
      #workspaces button:hover {
            color: #${theme.base02};
            background: #${theme.base04};
            border-radius: 15px;
            opacity: 1.0;
      }
      tooltip {
          background: #${theme.base00};
          border: 1px solid #${theme.base04};
          border-radius: 10px;
      }
      tooltip label {
          color: #${theme.base07};
      }
      #window {
            color: #${theme.base05};
            background: #${theme.base00};
            border-radius: 0px 15px 50px 0px;
            margin: 5px 5px 5px 0px;
            padding: 2px 20px;
      }
      #memory {
            color: #${theme.base0F};
            background: #${theme.base00};
            border-radius: 15px 50px 15px 50px;
            margin: 5px;
            padding: 2px 20px;
      }
      #clock {
            color: #${theme.base0B};
            background: #${theme.base00};
            border-radius: 15px 50px 15px 50px;
            margin: 5px;
            padding: 2px 20px;
      }
      #idle_inhibitor {
            color: #${theme.base0A};
            background: #${theme.base00};
            border-radius: 50px 15px 50px 15px;
            margin: 5px;
            padding: 2px 20px;
      }
      #cpu {
            color: #${theme.base07};
            background: #${theme.base00};
            border-radius: 50px 15px 50px 15px;
            margin: 5px;
            padding: 2px 20px;
      }
      #disk {
            color: #${theme.base03};
            background: #${theme.base00};
            border-radius: 15px 50px 15px 50px;
            margin: 5px;
            padding: 2px 20px;
      }
      #battery {
            color: #${theme.base08};
            background: #${theme.base00};
            border-radius: 15px;
            margin: 5px;
            padding: 2px 20px;
      }
      #network {
            color: #${theme.base09};
            background: #${theme.base00};
            border-radius: 50px 15px 50px 15px;
            margin: 5px;
            padding: 2px 20px;
      }
      #tray {
            color: #${theme.base05};
            background: #${theme.base00};
            border-radius: 15px 0px 0px 50px;
            margin: 5px 0px 5px 5px;
            padding: 2px 20px;
      }
      #pulseaudio {
            color: #${theme.base0D};
            background: #${theme.base00};
            border-radius: 50px 15px 50px 15px;
            margin: 5px;
            padding: 2px 20px;
      }
      #custom-notification {
            color: #${theme.base0C};
            background: #${theme.base00};
            border-radius: 15px 50px 15px 50px;
            margin: 5px;
            padding: 2px 20px;
      }
        #custom-themeselector {
            color: #${theme.base0D};
            background: #${theme.base00};
            border-radius: 15px 50px 15px 50px;
            margin: 5px;
            padding: 2px 20px;
        }
      #custom-startmenu {
            color: #${theme.base03};
            background: #${theme.base00};
            border-radius: 50px 15px 50px 15px;
            margin: 5px;
            padding: 2px 20px;
      }
      #idle_inhibitor {
            color: #${theme.base09};
            background: #${theme.base00};
            border-radius: 15px 50px 15px 50px;
            margin: 5px;
            padding: 2px 20px;
      }
    '';
  };
}

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
    mkOption
    ;
  inherit (lib.xeta) mkOpt getHyprlandPkg getTheme;
  inherit (lib.xeta.serialize) toTOML;
  cfg = config.xeta.desktop.pyprland;
in
{
  options.xeta.desktop.pyprland = {
    enable = mkEnableOption "Enable Pyprland ( plugin system for Hyprland ).";

    settings = {
      keybindings = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              modifiers = mkOption {
                type = types.listOf types.str;
                default = [ ]; # Empty list means "$mod" will be used by default
                description = ''
                  List of modifier keys for the binding. If empty, "$mod" is assumed as the default modifier.
                  Explicitly specify modifiers (e.g., ["ALT"], ["$mod", "SHIFT"]) to override the default.
                '';
              };
              key = mkOption {
                type = types.str;
                description = "The key associated with the binding.";
              };
              action = mkOption {
                type = types.str;
                description = "The action to perform.";
              };
              args = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Optional arguments for the action.";
              };
            };
          }
        );
        default = [ ];
        description = "Keybindings for Pyprland.";
      };
    };
  };

  config =
    let
      launch_scratch = cmd: "pypr toggle ${cmd}; $dispatch $active_to_top";
    in
    mkIf cfg.enable {
      home.packages = with pkgs; [ pyprland ];

      home.file = {
        "/home/jules/.config/hypr/pyprland.toml" =
          let
            notify = dur: msg: "hyprctl notify 5 ${dur} \"green\" \"${msg}\"";
            launch =
              { name, cmd }:
              ''
                alacritty --class scratchpad-${name} -e ${cmd};
                ${notify "1000" "Launched ${name} scratchpad"}
              '';
          in
          {
            enable = true;
            text = (
              toTOML ({
                pyprland = {
                  plugins = [
                    "scratchpads"
                    "toggle_special"
                    "monitors"
                    "magnify"
                    "expose"
                    "system_notifier"
                    "fetch_client_menu"
                    "toggle_dpms"
                    "workspaces_follow_focus"
                  ];
                };

                workspaces_follow_focus = {
                  max_workspaces = 9;
                };

                expose = {
                  include_special = false;
                };

                scratchpads = {
                  btop = {
                    animation = "fromBottom";
                    command = "alacritty --class scratchpad-btop -e btop";
                    class = "scratchpad-btop";
                    lazy = true;
                    size = "75% 45%";
                  };

                  calculator = {
                    animation = "fromLeft";
                    command = "alacritty --class scratchpad-calculator -e gnome-calculator";
                    class = "scratchpad-calculator";
                    size = "75% 45%";
                  };

                  snapchat = {
                    animation = "fromBottom";
                    command = launch {
                      name = "snapchat";
                      cmd = "chromium --app=https://web.snapchat.com/";
                    };
                    class = "scratchpad-calculator";
                    size = "65% 65%";
                  };

                  webcord = {
                    animation = "fromBottom";
                    command = launch {
                      name = "webcord";
                      cmd = "webcord";
                    };
                    class = "scratchpad-webcord";
                    size = "65% 65%";
                  };

                  alacritty = {
                    animation = "fromBottom";
                    command = "alacritty --class scratchpad-alacritty -e zellij options --theme catppuccin-mocha";
                    class = "scratchpad-alacritty";
                    size = "80% 80%";
                  };

                  volume = {
                    animation = "fromLeft";
                    command = "pavucontrol";
                    class = "scratchpad-pavucontrol";
                    lazy = true;
                    size = "40% 40%";
                  };

                  bitwarden = {
                    animation = "fromTop";
                    command = "bitwarden";
                    class = "scratchpad-bitwarden";
                    size = "65% 65%";
                  };
                };

                monitors = {
                  unknown = "wlrlui";
                };

                system_notifier = {
                  sources = [
                    {
                      command = "sudo journalctl -fx";
                      parser = "journal";
                    }
                  ];

                  parsers = {
                    journal = [
                      {
                        pattern = "([a-z0-9]+): Link UP$";
                        filter = "s/.*[d+]: ([a-z0-9]+): Link.*/1 is active/";
                        color = "#00aa00";
                      }
                      {
                        pattern = "([a-z0-9]+): Link DOWN$";
                        filter = "s/.*[d+]: ([a-z0-9]+): Link.*/1 is inactive/";
                        color = "#ff8800";
                      }
                      {
                        pattern = "Process d+ (.*) of .* dumped core.";
                        filter = "s/.*Process d+ ((.*)) of .* dumped core./1 dumped core/";
                        color = "#aa0000";
                      }
                      {
                        pattern = "usb d+-[0-9.]+: Product: ";
                        filter = "s/.*usb d+-[0-9.]+: Product: (.*)/USB plugged: 1/";
                      }
                    ];
                  };
                };
              })
            );
          };
      };

      wayland.windowManager.hyprland = {
        settings = {
          "$mod" = "ALT";
          "$dispatch" = "hyprctl dispatch";
          "$active_to_top" = "bringactivetotop";

          "$scratch_size" = "size 65% 50%";
          "$scratch" = "class:scratchpad";

          # █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█   █▀█ █░█ █░░ █▀▀ █▀
          # ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀   █▀▄ █▄█ █▄▄ ██▄ ▄█

          windowrulev2 = [
            "float, $scratch"
            "$scratch_size, $scratch"
            "workspace special scratch, $scratch"
            "float,class:scratchpad"
            "center,class:scratchpad"
          ];

          windowrule = [

          ];

          # ▄▀█ █░█ ▀█▀ █▀█    █▀▀ ▀▄▀ █▀▀ █▀▀
          # █▀█ █▄█ ░█░ █▄█    ██▄ █░█ ██▄ █▄▄

          exec-once = [ "pypr" ];

          # █▀ █░█ █▀█ █▀█ ▀█▀ █▀▀ █░█ ▀█▀ █▀
          # ▄█ █▀█ █▄█ █▀▄ ░█░ █▄▄ █▄█ ░█░ ▄█

          bind = [
            # pyprland workspaces_follow_focus
            # "$mod, H, exec, pypr shift_monitors -1"
            "$mod, K, exec, pypr change_workspace +1"
            "$mod, J, exec, pypr change_workspace -1"
            # "$mod, L, exec, pypr shift_monitors +1"

            # "$mod SHIFT, right, exec, pypr change_workspace +1"
            # "$mod SHIFT, left, exec, pypr change_workspace -1"

            # "$mod SHIFT, K, exec, pypr shift_monitors +1"
            # "$mod SHIFT, J, exec, pypr shift_monitors -1"

            # "SUPER, mouse_up, exec, pypr change_workspace +1"
            # "SUPER, mouse_down, exec, pypr change_workspace -1"

            #  $dispatch $active_to_top; hyprctl dispatch exec $terminal
            "SUPER, SPACE, exec, togglespecialworkspace, terminal;"
            "$mod SUPER, SPACE, exec, pypr toggle_special terminal"

            "SUPER, TAB, exec, togglespecialworkspace, files"
            "$mod SUPER, TAB, exec, pypr toggle_special files"

            "SUPER, F1, exec, togglespecialworkspace, sandbox"
            "$mod SUPER, F1, exec, pypr toggle_special sandbox"

            "SUPER, F2, exec, togglespecialworkspace, special"
            "$mod SUPER, F2, exec, pypr toggle_special special"

            "SUPER, P, exec, pypr toggle bitwarden; $dispatch $active_to_top"
            "SUPER, D, exec, pypr toggle webcord; $dispatch $active_to_top"
            "SUPER, V, exec, pypr toggle volume; $dispatch $active_to_top"
            "SUPER, B, exec, pypr toggle btop; $dispatch $active_to_top"
            "SUPER, =, exec, pypr toggle calculator; $dispatch $active_to_top"
            "SUPER, ENTER, exec, pypr toggle alacritty; $dispatch $active_to_top"

            "$mod, N, togglespecialworkspace, stash" # toggles "stash" special workspace visibility
            "$mod SHIFT, N, exec, pypr toggle_special stash" # moves windows to/from the "stash" workspace

            "SUPER SHIFT, C, togglespecialworkspace, minimize"
            "SUPER, C, exec, pypr toggle_special minimize"

            # toggles special "expose" workspace which is
            # used to show all windows in an overview
            "SUPER, A, exec, pypr expose"
          ];
        };
      };
    };
}

{ lib, pkgs, config, inputs, system, ... }:
let
  inherit (lib) types mkEnableOption mkIf mkOption;
  inherit (lib.xeta) mkOpt getHyprlandPkg getTheme;
  cfg = config.xeta.desktop.pyprland;
in {
  options.xeta.desktop.pyprland = {
    enable = mkEnableOption "Enable Pyprland ( plugin system for Hyprland ).";

    settings = {
      keybindings = mkOption {
        type = types.listOf (types.submodule {
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
        });
        default = [ ];
        description = "Keybindings for Pyprland.";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ pyprland ];

    home.file = {
      "/home/jules/.config/hypr/pyprland.toml" = {
        enable = true;
        source = ./pyprland.toml;
      };
    };

    wayland.windowManager.hyprland = {
      settings = {
        "$mod" = "ALT";
        "$dispatch" = "hyprctl dispatch";
        "$active_to_top" = "bringactivetotop";

        "$scratch_size" = "size 80% 85%";
        "$scratch" = "class:scratchpad";

        # █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█   █▀█ █░█ █░░ █▀▀ █▀
        # ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀   █▀▄ █▄█ █▄▄ ██▄ ▄█

        windowrulev2 = [
          "float, $scratch"
          "$scratch_size, $scratch"
          "workspace special silent, $scratch"
          "center, $scratch"
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
          "$mod, K, exec, pypr change_workspace +1"
          "$mod, J, exec, pypr change_workspace -1"

          "$mod SHIFT, right, exec, pypr change_workspace +1"
          "$mod SHIFT, left, exec, pypr change_workspace -1"

          "$mod SHIFT, K, exec, pypr shift_monitors +1"
          "$mod SHIFT, J, exec, pypr shift_monitors -1"

          "SUPER, mouse_up, exec, pypr change_workspace +1"
          "SUPER, mouse_down, exec, pypr change_workspace -1"

          "SUPER, B, exec, pypr toggle btop; $dispatch $active_to_top"

          "$mod SHIFT, N, togglespecialworkspace, stash" # toggles "stash" special workspace visibility
          "$mod, N, exec, pypr toggle_special stash" # moves window to/from the "stash" workspace

          # toggles special "expose" workspace which is
          # used to show all windows in an overview
          "SUPER, A, exec, pypr expose"
        ];
      };
    };
  };
}

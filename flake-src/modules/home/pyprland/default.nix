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
    home.packages = with pkgs; [ pypr ];

    home.file.${"~/.config/hypr/pyprland.toml"}.text =
      (builtins.readFile ./pyprland.toml);

    wayland.windowManager.hyprland = {
      settings = {
        "$mod" = "ALT";
        "$notify" =
          "notify-send -h string:x-canonical-private-synchronous:hypr-cfg -u low";

        # █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█   █▀█ █░█ █░░ █▀▀ █▀
        # ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀   █▀▄ █▄█ █▄▄ ██▄ ▄█

        windowrulev2 = [
          "float,class:^(kitty)$,title:^(kitty)$"
          "float,class:^(Bitwarden)$"
          "float,class:^(thunar)$"
          "float,title:^(?i).*Bitwarden.*$"
          "float,title:^(?i).*Extension:.*$"
          "float,title:^(?i).*Sign in.*$"
          "idleinhibit focus, class:^(vlc)$"
          "idleinhibit fullscreen, class:^(floorp)$"
        ];
        windowrule = [
          "float, ^(steam)$"
          "center, ^(steam)$"
          "size 1200 900, ^(steam)$"
          "float,^(alacritty)$"
          "move 0 0,class:^(floorp)(.*)$"
        ];

        # ▄▀█ █░█ ▀█▀ █▀█    █▀▀ ▀▄▀ █▀▀ █▀▀
        # █▀█ █▄█ ░█░ █▄█    ██▄ █░█ ██▄ █▄▄

        exec-once = [ "pypr" ];

        # █▀ █░█ █▀█ █▀█ ▀█▀ █▀▀ █░█ ▀█▀ █▀
        # ▄█ █▀█ █▄█ █▀▄ ░█░ █▄▄ █▄█ ░█░ ▄█

        bind = [
          # F keypress
          "$mod, F, exec, floorp"
        ];
      };
    };
  };
}

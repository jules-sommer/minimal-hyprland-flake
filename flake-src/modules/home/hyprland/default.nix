{ lib, pkgs, config, inputs, system, ... }:
let
  inherit (lib) types mkEnableOption mkIf mkOption;
  inherit (lib.xeta) mkOpt getHyprlandPkg getTheme;
  cfg = config.xeta.desktop.hyprland;
  get_time = ''
    #!/run/current-system/sw/bin/nu
    date now | date to-timezone "America/Toronto" | format date "%a, %B %d %I:%M %p"
  '';
  theme = getTheme cfg.theme;
in {
  options.xeta.desktop.hyprland = {
    enable = mkEnableOption "Enable Hyprland (@/home-manager)";
    theme = mkOpt (types.nullOr types.str) "synth-midnight-dark" "Theme to use";

    settings = {
      modifier =
        mkOpt (types.nullOr types.enum ([ "CTRL" "ALT" "SUPER" ])) "ALT"
        "Modifier key to use for Hyprland keybindings.";
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
        description = "Keybindings for Hyprland.";
      };

      actions = mkOpt (types.attrsOf (types.submodule {
        options = {
          command = mkOpt (types.nullOr types.str) null
            "The command to execute for this action.";
          description =
            mkOpt (types.nullOr types.str) null "A description of the action.";
        };
      })) { } "Default actions for Hyprland.";

      applications = mkOpt (types.attrsOf (types.submodule { })) {
        options = {
          command = mkOpt (types.nullOr types.str) null
            "The command to execute for this application.";
          script = mkOpt (types.nullOr types.path) null
            "The path of the script to execute for this application.";
          description = mkOpt (types.nullOr types.str) null
            "A description of the application or script and it's function.";
        };
      } "Default applications for Hyprland.";

      defaults = {
        terminal = mkOpt (types.nullOr types.str) "alacritty"
          "Default terminal to use for Hyprland.";
        file_manager = {
          gui = mkOpt (types.nullOr types.str) "thunar"
            "Default GUI file manager to use for Hyprland.";
          tui = mkOpt (types.nullOr types.str) "alacritty -e ranger"
            "Default TUI file manager to use for Hyprland.";
        };
        menu = mkOpt (types.nullOr types.str) "rofi -show drun"
          "Default menu command to use for Hyprland.";
        screenshot =
          mkOpt (types.nullOr types.str) "nu ~/_dev/nu_tools/screenshot.nu"
          "Default screenshot command to use for Hyprland.";
        clipboard_manager = mkOpt (types.nullOr types.str)
          "cliphist list | wofi --dmenu | cliphist decode | wl-copy"
          "Default clipboard manager command to use for Hyprland.";
        notifycmd = mkOpt (types.nullOr types.str)
          "notify-send -h string:x-canonical-private-synchronous:hypr-cfg -u low"
          "Default notification command to use for Hyprland.";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ swww eww hyprpaper swayidle swaylock swaybg ];
    wayland.windowManager.hyprland = {
      enable = true;
      package = getHyprlandPkg system;
      xwayland.enable = true;
      systemd.enable = true;
      settings = {
        "$mod" = "ALT";
        "$terminal" = "alacritty";
        "$files" = "alacritty -e joshuto";
        "$screenshot" = "nu ~/_dev/nu_tools/screenshot.nu";
        "$menu" = "rofi -show drun";
        "$notify" =
          "notify-send -h string:x-canonical-private-synchronous:hypr-cfg -u low";
        monitor = [
          "DP-1,2560x1080@74.99,1920x0,1"
          "HDMI-A-2,1920x1080@100,0x0,1"
          ",highres,auto,1"
        ];
        env = [
          "NIXOS_OZONE_WL, 1"
          "NIXPKGS_ALLOW_UNFREE, 1"

          # Theming related
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
          "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
          "QT_QPA_PLATFORMTHEME,qt5ct"
          "XCURSOR_SIZE,24"
          "XCURSOR_THEME, Bibata-Modern-Ice"

          # Wayland related
          "MOZ_ENABLE_WAYLAND, 1"

          # nvidia related
          "GDK_BACKEND=wayland,x11" # use wayland if available, fallback to x11
          "CLUTTER_BACKEND, wayland"
          "SDL_VIDEODRIVER, wayland"
          "LIBVA_DRIVER_NAME,nvidia"
          "XDG_SESSION_TYPE,wayland"
          "XDG_CURRENT_DESKTOP, Hyprland"
          "XDG_SESSION_DESKTOP, Hyprland"
          "GBM_BACKEND,nvidia-drm"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "WLR_NO_HARDWARE_CURSORS,1"
        ];

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

        exec-once = [
          "hyprpaper"
          "pueued -dv"
          "$POLKIT_BIN"
          "nm-applet --indicator"
          # "dbus-update-activation-environment --systemd --all"
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "hyprctl setcursor Bibata-Modern-Ice 24"
          "swww init"
          "waybar"
          "swaync"
          "swayidle -w timeout 720 'swaylock -f' timeout 800 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock -f -c 000000'"
          "swww img --filter Lanczos3 ~/Pictures/wallpapers/zoelove.jpg"
          # "swaybg - m fill - i ~/Pictures/wallpapers/zoelove.jpg" # alternative to swww for wallpaper
        ];

        # █▀ █░█ █▀█ █▀█ ▀█▀ █▀▀ █░█ ▀█▀ █▀
        # ▄█ █▀█ █▄█ █▀▄ ░█░ █▄▄ █▄█ ░█░ ▄█

        bindm =
          [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];
        bind = [
          # F keypress
          "$mod, F, exec, floorp"
          "$mod SHIFT, F, togglefloating, "
          # C keypress
          "$mod, C, killactive, "
          # M keypress
          "$mod, M, exit, "
          # W keypress
          "$mod, W, exec, $menu"
          "$mod SHIFT, W, exec, $terminal"

          "$mod SHIFT,I,togglesplit"

          "$mod, E, exec, $gui_files"
          "$mod SHIFT, E, exec, $tui_files"
          "CTRL SHIFT, S, exec, $screenshot"
          "$mod, D, exec, swaync-client -t"
          # Terminal and Alacritty for $mod + {T, A}
          "$mod, T, exec, $terminal $multiplexer"
          "$mod SHIFT, T, exec, $terminal"
          # File manager $mod + {F}
          "$mod, P, pseudo, # dwindle"
          "$mod, J, togglesplit, # dwindle"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod SHIFT, SPACE, movetoworkspace,special"
          "$mod, SPACE, togglespecialworkspace"

          "$mod SHIFT, mouse_up, workspace, e+1"
          "$mod SHIFT, mouse_down, workspace, e-1"
          "ALT,Tab,cyclenext"
          "ALT,Tab,bringactivetotop"

          ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
          ",XF86MonBrightnessUp,exec,brightnessctl set +5"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioPlay, exec, playerctl play-pause"
          ",XF86AudioPause, exec, playerctl play-pause"
          ",XF86AudioNext, exec, playerctl next"
          ",XF86AudioPrev, exec, playerctl previous"

          # clipboard manager with wofi
          "$mod SHIFT, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
        ] ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (x:
            let
              ws = let c = (x + 1) / 10;
              in builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
            ]) 10));

        # ▄▀█ █▄░█ █ █▀▄▀█ ▄▀█ ▀█▀ █ █▀█ █▄░█ █▀
        # █▀█ █░▀█ █ █░▀░█ █▀█ ░█░ █ █▄█ █░▀█ ▄█
        #                                        
        # ▄▀█ █▄░█ █▀▄    █▀▄ █▀▀ █▀▀ █▀█ █▀█ █▀
        # █▀█ █░▀█ █▄▀    █▄▀ ██▄ █▄▄ █▄█ █▀▄ ▄█

        animations = {
          enabled = "yes";
          bezier = [
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "liner, 1, 1, 1, 1"
          ];
          animation = [
            "windows, 1, 6, wind, slide"
            "windowsIn, 1, 6, winIn, slide"
            "windowsOut, 1, 5, winOut, slide"
            "windowsMove, 1, 5, wind, slide"
            "border, 1, 1, liner"
            "borderangle, 1, 30, liner, loop"
            "fade, 1, 10, default"
            "workspaces, 1, 5, wind"
          ];
        };

        decoration = {
          rounding = "15";
          drop_shadow = true;
          blur = {
            enabled = true;
            size = "5";
            passes = "3";
            new_optimizations = "on";
            ignore_opacity = "on";
          };
        };

        # █▀▄▀█ █ █▀ █▀▀ ░
        # █░▀░█ █ ▄█ █▄▄ ▄

        general = {
          "gaps_in" = 6;
          "gaps_out" = 8;
          "border_size" = 2;
          "col.active_border" =
            "rgba(${theme.base0C}ff) rgba(${theme.base0D}ff) rgba(${theme.base0B}ff) rgba(${theme.base0E}ff) 45deg";
          "col.inactive_border" =
            "rgba(${theme.base0C}40) rgba(${theme.base0D}40) rgba(${theme.base0B}40) rgba(${theme.base0E}40) 45deg";
          "layout" = "dwindle";
          "resize_on_border" = "true";
        };

        input = {
          kb_layout = "us";
          # kb_options = [ "grp:alt_shift_toggle" "caps:super" ];
          kb_options = [ "caps:swapescape" ];
          follow_mouse = 1;
          touchpad = { natural_scroll = false; };
          sensitivity = 0.5; # -1.0 - 1.0, 0 means no modification.
          accel_profile = "adaptive";
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 3;
        };

        misc = {
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = false;
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        master = { new_is_master = true; };

        plugin = {
          # optional plugin configuration here
        };

        misc = {
          vrr = 2;
          disable_hyprland_logo = 1;
        };
      };
    };
  };
}

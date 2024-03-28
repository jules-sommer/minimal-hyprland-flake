## <span style="display:flex;align-items: end;">Hyprland Module <span style="font-size: 12px; margin-left: auto; display: flex; flex-direction: column; align-items: end;"><span>[ home-manager module ]</span><span style="font-family: 'JetBrainsMono', monospace;">[xeta.home.desktop.hyprland]</span></span></span>

The Hyprland module for NixOS/Home Manager enables configuration of Hyprland, a dynamic tiling Wayland compositor. This module provides customizable options for themes, keybindings, actions, and applications.

1. **Enabling Hyprland**

    ***enable***: Set to true to activate the Hyprland configuration within NixOS/Home Manager. This requires that the equivalent system configuration option is also set to true.

#### Example user-space usage:
<span style="font: 'JetBrainsMono' monospace !important;">

```nix
{ config, lib, pkgs, ... }:

{
  xeta.home.desktop.hyprland = {
    enable = true;
    theme = "synth-midnight-dark";

    settings = {
      modifier = "SUPER";

      keybindings = [
        {
          modifiers = [ "SUPER" ];
          key = "Return";
          action = "openTerminal";
        }
        {
          modifiers = [ "SUPER", "SHIFT" ];
          key = "d";
          action = "launchFileManager";
        }
      ];

      actions = {
        openTerminal = {
          command = "${pkgs.alacritty}/bin/alacritty";
          description = "Opens the Alacritty terminal.";
        };
        launchFileManager = {
          command = "${pkgs.thunar}/bin/thunar";
          description = "Launches Thunar file manager.";
        };
      };

      applications = {
        rofi = {
          command = "${pkgs.rofi}/bin/rofi -show run";
          description = "Application launcher";
        };
        screenshot = {
          script = /path/to/screenshot/script.sh;
          description = "Takes a fullscreen screenshot.";
        };
      };
    };
  };
}
```

</span>

## Configuration Options

#### Theme

- **`theme`**: Sets the theme for Hyprland. Default is `"synth-midnight-dark"`.

#### Modifier Key

- **`settings.modifier`**: Specifies the default modifier key for Hyprland keybindings. Supported values are `"CTRL"`, `"ALT"`, and `"SUPER"`. The default is `"ALT"`.

#### Keybindings

- **`settings.keybindings`**: An array defining the keybindings. Each keybinding is an attribute set containing `modifiers`, a `key`, an `action`, and optionally `args`. By default, `$mod` is assumed as the modifier if none are specified.

#### Actions

- **`settings.actions`**: Attribute set defining actions for keybindings. Each action must include a `command` and can optionally provide a `description`.

#### Applications

- **`settings.applications`**: Defines shortcuts for applications. Each application configuration may include a `command` or a `script`, along with an optional `description`.

### Defining Keybindings

Keybindings are specified as a list of attribute sets, with each set requiring `modifiers`, `key`, and an `action`. Actions are referenced by their names as defined under `settings.actions`.

### Actions and Applications

- **Actions**: Commands linked to keybindings. They require a `command` to execute and may include a `description`.
- **Applications**: Intended for application shortcuts, allowing specification of either a `command` or a `script`, with an optional `description`.

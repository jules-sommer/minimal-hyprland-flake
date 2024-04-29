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
  cfg = config.xeta.input;
in
{
  options.xeta.input = {
    kbd = {
      enable = mkEnableOption "Enable kbd-input related configuration.";
      layout = mkOpt (types.str) "us" "Keyboard layout to use, i.e 'us', 'fr', etc.";
      variant = mkOpt (types.str) "" "Keyboard layout variant to use, i.e 'colemak', 'dvorak', etc.";
    };
  };

  config = mkIf cfg.kbd.enable {
    console.useXkbConfig = true;
    services.xserver = {
      libinput.enable = true;
      xkb = {
        layout = cfg.kbd.layout;
        variant = cfg.kbd.variant;
      };
    };

    services.xremap.withWlroots = true;
    services.xremap.config = {
      # Modmap for single key rebinds
      modmap = [
        {
          name = "Swap Caps Lock and Escape";
          remap = {
            KEY_CAPSLOCK = "KEY_ESC";
            KEY_ESC = "KEY_CAPSLOCK";
          };
        }
      ];

      # Keymap for key combo rebinds
      keymap = [ ];
    };
  };
}

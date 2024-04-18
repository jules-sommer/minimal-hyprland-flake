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
  cfg = config.xeta.system.input.kbd;
in
{
  options.xeta.system.input = {
    kbd = {
      enable = mkEnableOption "Enable kbd-input related configuration.";
      layout = mkOpt (types.str) "us" "Keyboard layout to use, i.e 'us', 'fr', etc.";
      variant = mkOpt (types.str) "" "Keyboard layout variant to use, i.e 'colemak', 'dvorak', etc.";
    };
  };

  config = mkIf cfg.enable {
    console.useXkbConfig = true;
    services.xserver = {
      libinput.enable = true;
      xkb = {
        layout = cfg.layout;
        variant = cfg.variant;
      };
    };

    services.xremap.withWlroots = true;
    services.xremap.config = {
      # Modmap for single key rebinds
      modmap = [
        {
          name = "Global";
          remap = {
            CapsLock = "Escape";
            Escape = "CapsLock";
            # "CapsLock" = {
            #   held = "KEY_SUPER_L";
            #   alone = "Escape";
            #   alone_timeout_millis = 150;
            # };
          };
        }
      ];

      # Keymap for key combo rebinds
      keymap = [
        {
          # Rebind shift+escape to tilda
          name = "Shift+Esc > Tilda";
          remap = {
            "SHIFT_L-Esc" = "KEY_GRAVE";
          };
        }
        {
          # Rebind shift+escape to tilda
          name = "Shift+Esc > Tilda";
          remap = {
            "C_L-SHIFT_L-Esc" = "C-SHIFT-KEY_GRAVE";
          };
        }
        {
          # Rebind shift+escape to tilda
          name = "Shift+Esc > Tilda";
          remap = {
            "Escape" = {
              held = "KEY_CAPSLOCK";
              alone = "KEY_GRAVE";
              alone_timeout_millis = 150; # Adjust the timeout as needed
            };
          };
        }
      ];
    };
  };
}

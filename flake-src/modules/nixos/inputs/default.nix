{ lib, pkgs, config, inputs, system, ... }:
let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.xeta) mkOpt;
  cfg = config.xeta.system.input.kbd;
in {
  options.xeta.system.input = {
    kbd = {
      enable = mkEnableOption "Enable kbd-input related configuration.";
      layout =
        mkOpt (types.str) "us" "Keyboard layout to use, i.e 'us', 'fr', etc.";
      variant = mkOpt (types.str) ""
        "Keyboard layout variant to use, i.e 'colemak', 'dvorak', etc.";
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
  };
}

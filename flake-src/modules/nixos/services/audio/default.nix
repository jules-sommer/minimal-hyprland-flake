{ lib, pkgs, config, inputs, system, ... }:
let
  inherit (lib) types mkEnableOption mkIf mkOpt;
  cfg = config.xeta.system.services.audio;
in {
  options.xeta.system.services.audio = {
    pipewire = {
      enable = mkEnableOption "Enable PipeWire";
      support = {
        alsa = mkEnableOption "Support ALSA";
        pulse = mkEnableOption "Support PulseAudio";
        jack = mkEnableOption "Support JACK";
      };
    };
  };

  config = mkIf cfg.pipewire.enable {
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = cfg.pipewire.support.alsa;
      alsa.support32Bit = cfg.pipewire.support.alsa;
      pulse.enable = cfg.pipewire.support.pulse;
      jack.enable = cfg.pipewire.support.jack;
      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };
}
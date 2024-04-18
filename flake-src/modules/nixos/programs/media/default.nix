{
  lib,
  pkgs,
  config,
  inputs,
  system,
  ...
}:
let
  inherit (lib.xeta) enabled;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.xeta.programs.media;
in
{
  options.xeta.programs.media = {
    enable = mkEnableOption "Enable media configuration";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enable == true || cfg.enable == false;
        message = "xeta.programs.media.enable must be true or false";
      }
    ];
    environment.systemPackages = with pkgs; [
      vlc
      mpv
      swayimg
      ctpv
      ffmpeg
      termimage
      timg
    ];
  };
}

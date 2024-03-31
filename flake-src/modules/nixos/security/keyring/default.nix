{ options, config, lib, pkgs, ... }:

with lib;
with lib.xeta;
let cfg = config.xeta.security.keyring;
in {
  options.xeta.security.keyring = with types; {
    enable = mkBoolOpt false "Whether to enable gnome keyring.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnome.gnome-keyring
      gnome.libgnome-keyring
    ];
  };
}

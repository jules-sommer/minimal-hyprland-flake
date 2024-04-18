{
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;
with lib.xeta;
let
  cfg = config.xeta.services.ollama;
  home = config.xeta.system.user.home;
in
{
  options.xeta.services.ollama = with types; {
    enable = mkBoolOpt false "Whether to enable local AI models via Ollama.";
  };

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      package = pkgs.ollama;
      home = "${home}/070_dotfiles/";
      listenAddress = "127.0.0.1:11434";
      # acceleration = "cuda";
    };
    environment.systemPackages = with pkgs; [
      ollama
      oterm
    ];
  };
}

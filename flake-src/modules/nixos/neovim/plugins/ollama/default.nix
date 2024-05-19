{ pkgs
, config
, lib
, inputs
, ...
}:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.xeta) disabled enabled list path optional mkOpt;

  cfg = config.xeta.nixvim.plugins.ollama;
in
{
  options.xeta.nixvim.plugins.ollama = {
    enable = mkEnableOption "Enable neovim config via nixvim.";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.ollama = {
      enable = true;
      action = "display_replace";
      model = "llama3";
      serve = {
        onStart = false;
      };
    };
  };
}

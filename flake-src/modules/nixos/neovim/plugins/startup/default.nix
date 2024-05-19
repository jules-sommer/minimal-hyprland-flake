{ pkgs
, config
, lib
, inputs
, ...
}:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.xeta) disabled enabled list path optional mkOpt;
  inherit (pkgs.xeta) supermaven-nvim;

  plugins = pkgs.vimPlugins;
  theme = lib.xeta.getTheme "tokyo-night-dark";

  cfg = config.xeta.nixvim.plugins.startup;
in
{
  options.xeta.nixvim.plugins.startup = {
    enable = mkEnableOption "Enable neovim startup plugin via nixvim.";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins.startup = {
        enable = true;
        theme = "dashboard";
      };
    };
  };
}


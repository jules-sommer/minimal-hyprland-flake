{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.xeta.zellij;
in
{
  options.xeta.zellij = {
    enable = mkEnableOption "Enable zellij.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ zellij ];
    programs.zellij = {
      enable = true;

      settings.theme = "catppuccin-mocha";
      settings.defaultLayout = "compact";
      settings.defaultMode = "locked";

      # keybinds
      settings.keybinds = {
        normal = {};
      };

      # plugins
      settings.plugins = {
        zjharpoon = {
          path = "${pkgs.zjharpoon}/bin/zjharpoon.wasm";
        };
        zjstatus = {
          path = "${pkgs.zjstatus}/bin/zjstatus.wasm";
        };
        monocle = {
          path = "${pkgs.zjmonocle}/bin/zjmonocle.wasm";
        };
      };
    };
  };
}

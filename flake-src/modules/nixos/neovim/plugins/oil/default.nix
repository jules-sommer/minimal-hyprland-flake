{ pkgs
, config
, lib
, inputs
, ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.xeta) disabled enabled list mkOpt;
  inherit (pkgs.xeta) treesitter-nu supermaven-nvim;

  home = config.xeta.system.user.home;
  plugins = pkgs.vimPlugins;
  theme = lib.xeta.getTheme "tokyo-night-dark";

  cfg = config.xeta.nixvim.plugins.oil;
in
{
  options.xeta.nixvim.plugins.oil = {
    enable = mkEnableOption "Enable oil";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.oil = {
      enable = true;
      settings = {
        skip_confirm_for_simple_edits = true;
        keymaps = {
          "g?" = "actions.show_help";
          "<CR>" = "actions.select";
          "<C-s>" = "actions.select_vsplit";
          "<C-h>" = "actions.select_split";
          "<C-t>" = "actions.select_tab";
          "<C-p>" = "actions.preview";
          "<C-c>" = "actions.close";
          "<C-l>" = "actions.refresh";
          "-" = "actions.parent";
          "_" = "actions.open_cwd";
          "" = "actions.cd";
          "~" = "actions.tcd";
          gs = "actions.change_sort";
          gx = "actions.pen_external";
          "g." = "actions.toggle_hidden";
          "g\\" = "actions.toggle_trash";
        };
      };
    };
  };
}





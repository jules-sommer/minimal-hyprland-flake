{ pkgs
, config
, lib
, inputs
, ...
}:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.xeta) disabled enabled list path optional mkOpt;

  cfg = config.xeta.nixvim.plugins.obsidian;
in
{
  options.xeta.nixvim.plugins.obsidian = {
    enable = mkEnableOption "Enable obsidian";
  };

  config = mkIf cfg.enable
    {
      programs.nixvim = {
        plugins.obsidian = {
          enable = true;
          settings = {
            workspaces = [
              {
                name = "jules-main";
                path = "~/010_documents";
              }
              {
                name = "jules-old";
                path = "~/_vault";
              }
            ];
            new_notes_location = "current_dir";
            completion = {
              nvim_cmp = true;
              min_chars = 1;
            };
          };
        };
      };
    };
}

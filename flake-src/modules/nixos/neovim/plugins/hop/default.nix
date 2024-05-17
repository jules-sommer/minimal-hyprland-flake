{ pkgs
, config
, lib
, inputs
, ...
}:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.xeta) disabled enabled list path optional mkOpt;

  cfg = config.xeta.nixvim.plugins.hop;
in
{
  options.xeta.nixvim.plugins.hop = {
    enable = mkEnableOption "Enable hop plugin.";
  };

  config = mkIf cfg.enable
    {
      programs.nixvim = {
        plugins.hop = enabled;
        keymaps = [
          {
            key = "f";
            lua = true;
            action = ''
              function()
                require('hop').hint_char1({
                  direction = require'hop.hint'.HintDirection.AFTER_CURSOR,
                  current_line_only = true
                })
              end
            '';
            options.noremap = true;
          }
          {
            key = "F";
            lua = true;
            action = ''
              function()
                require('hop').hint_char1({
                  direction = require'hop.hint'.HintDirection.BEFORE_CURSOR,
                  current_line_only = true
                })
              end
            '';
            options.noremap = true;
          }
          {
            key = "t";
            lua = true;
            action = ''
              function()
                require('hop').hint_char1({
                  direction = require'hop.hint'.HintDirection.AFTER_CURSOR,
                  current_line_only = true,
                  hint_offset = -1
                })
              end
            '';
            options.noremap = true;
          }
          {
            key = "T";
            lua = true;
            action = ''
              function()
                require('hop').hint_char1({
                  direction = require'hop.hint'.HintDirection.BEFORE_CURSOR,
                  current_line_only = true,
                  hint_offset = 1
                })
              end
            '';
            options.noremap = true;
          }
        ];
      };
    };
}

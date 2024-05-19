{ pkgs
, config
, lib
, inputs
, ...
}:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.xeta) disabled enabled list path optional mkOpt;

  cfg = config.xeta.nixvim.plugins.smartsplits;
in
{
  options.xeta.nixvim.plugins.smartsplits = {
    enable = mkEnableOption "Enable LSP configuration and plugins.";
  };

  config = mkIf cfg.enable
    {
      programs.nixvim = {
        plugins = {
          smart-splits = enabled;
        };
        keymaps = [{
          action = "require('smart-splits').resize_left";
          lua = true;
          key = "<C-S-h>";
          options.noremap = true;
        }
          {
            action = "require('smart-splits').resize_down";
            lua = true;
            key = "<C-S-j>";
            options.noremap = true;
          }
          {
            action = "require('smart-splits').resize_up";
            lua = true;
            key = "<C-S-k>";
            options.noremap = true;
          }
          {
            action = "require('smart-splits').resize_right";
            lua = true;
            key = "<C-S-l>";
            options.noremap = true;
          }
          {
            action = "require('smart-splits').move_cursor_left";
            lua = true;
            key = "<C-h>";
            options.noremap = true;
          }
          {
            action = "require('smart-splits').move_cursor_down";
            lua = true;
            key = "<C-j>";
            options.noremap = true;
          }
          {
            action = "require('smart-splits').move_cursor_up";
            lua = true;
            key = "<C-k>";
            options.noremap = true;
          }
          {
            action = "require('smart-splits').move_cursor_right";
            lua = true;
            key = "<C-l>";
            options.noremap = true;
          }
          {
            action = "require('smart-splits').move_cursor_previous";
            lua = true;
            key = "<C-\\>";
            options.noremap = true;
          }
          {
            action = "require('smart-splits').swap_buf_left";
            lua = true;
            key = "<leader><leader>h";
            options.noremap = true;
          }
          {
            action = "require('smart-splits').swap_buf_down";
            lua = true;
            key = "<leader><leader>j";
            options.noremap = true;
          }
          {
            action = "require('smart-splits').swap_buf_up";
            lua = true;
            key = "<leader><leader>k";
            options.noremap = true;
          }
          {
            action = "require('smart-splits').swap_buf_right";
            lua = true;
            key = "<leader><leader>l";
            options.noremap = true;
          }];
      };
    };
}

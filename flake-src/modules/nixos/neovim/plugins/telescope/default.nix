{ config
, lib
, ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.xeta) enabled;

  home = config.xeta.system.user.home;
  cfg = config.xeta.nixvim.plugins.telescope;
in
{
  options.xeta.nixvim.plugins.telescope = {
    enable = mkEnableOption "Enable LSP configuration and plugins.";
  };

  config = mkIf cfg.enable
    {
      programs.nixvim = {
        plugins = {
          telescope = {
            enable = true;
            extensions = {
              frecency = {
                enable = true;
                settings = {
                  db_root = "${home}/.local/share/nvim/telescope/frecency";
                  disable_devicons = false;
                  db_safe_mode = false;
                  ignore_patterns = [
                    "*.git/*"
                    "*/tmp/*"
                  ];
                  show_scores = true;
                  show_unindexed = true;
                  workspaces = {
                    dev = "/home/jules/000_dev";
                    config = "/home/jules/000_dev/000_config/010_minimal-hyprland-flake";
                    data = "/home/jules/.local/share";
                  };
                };
              };
              fzf-native = enabled;
              media-files = enabled;
              ui-select = enabled;
            };
            keymaps = {
              "<leader>f" = "find_files";
              "<leader>g" = "live_grep";
            };
          };
        };
        keymaps = [
          {
            key = "<space>f";
            action = "<cmd>Telescope find_files<CR>";
            options = {
              desc = "Find files using Telescope";
              noremap = true;
            };
          }
          {
            action = "<cmd>Telescope live_grep<CR>";
            key = "<leader>g";
            options = {
              desc = "Live grep in current directory";
              noremap = true;
            };
          }
          {
            action = "<cmd>Telescope help_tags<CR>";
            key = "<leader>h";
            options = {
              desc = "Search help tags with Telescope";
              noremap = true;
            };
          }
          {
            action = "<cmd>Telescope buffers<CR>";
            key = "<leader>b";
            options = {
              desc = "List open buffers with Telescope";
              noremap = true;
            };
          }
          {
            action = "<cmd>Telescope current_buffer_fuzzy_find<CR>";
            key = "<leader>/";
            options = {
              desc = "Fuzzy find in current buffer with Telescope";
              noremap = true;
            };
          }
          {
            action = "<cmd>Telescope lsp_references<CR>";
            key = "gR";
            options = { noremap = true; desc = "Show LSP references"; };
          }
          {
            key = "gd";
            action = "<cmd>Telescope lsp_definitions<CR>";
            options = { noremap = true; desc = "Show LSP definitions"; };
          }
          {
            key = "gi";
            action = "<cmd>Telescope lsp_implementations<CR>";
            options = { noremap = true; desc = "Show LSP implementations"; };
          }
          {
            key = "gt";
            action = "<cmd>Telescope lsp_type_definitions<CR>";
            options = { noremap = true; desc = "Show LSP type definitions"; };
          }
          {
            action = "<cmd>Telescope diagnostics bufnr=0<CR>";
            key = "<leader>D";
            options = { noremap = true; desc = "Show buffer diagnostics"; };
          }
        ];
      };
    };
}

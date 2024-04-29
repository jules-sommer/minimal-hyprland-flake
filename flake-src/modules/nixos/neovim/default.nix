{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  plugins = pkgs.vimPlugins;
  theme = lib.xeta.getTheme "tokyo-night-dark";

  inherit (lib) mkEnableOption mkIf;
  inherit (lib.xeta) disabled;
  cfg = config.xeta.nixvim;
in
{
  options.xeta.nixvim = {
    enable = mkEnableOption "Enable handy Rust CLI utilities system-wide (e.g. ripgrep, fd-find, exa, bat, etc.)";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;

      globals.mapleader = " "; # Sets the leader key to space

      opts = {
        clipboard = "unnamedplus";
        number = true; # Show line numbers
        relativenumber = true; # Show relative line numbers
        shiftwidth = 2; # Tab width should be 2
        softtabstop = 2;
        tabstop = 2;
        smartindent = true;
        wrap = false;
        swapfile = false;
        backup = false;
        hlsearch = false;
        incsearch = true;
        termguicolors = true;
        scrolloff = 8;
        updatetime = 50;
      };

      colorschemes.tokyonight.enable = true;

      plugins = {
        crates-nvim.enable = true;
        lsp-format.enable = true;
        nix-develop.enable = true;
        barbecue.enable = true;
        gitsigns.enable = true;
        telescope = {
          enable = true;
          keymaps = {
            "<leader>ff" = "find_files";
            "<leader>lg" = "live_grep";
          };
        };
        indent-blankline.enable = true;
        nvim-colorizer.enable = true;
        nvim-autopairs.enable = true;
        nix.enable = true;
        comment.enable = true;
        lualine = {
          enable = true;
        };
        startup = {
          enable = true;
          theme = "dashboard";
        };
        lsp = {
          enable = true;
          servers = {
            lua-ls = {
              enable = true;
              settings = {
                telemetry = disabled;
              };
            };
            nushell.enable = true;
            tsserver.enable = true;
            htmx.enable = true;
            zls.enable = true;
            rnix-lsp.enable = true;
            bashls.enable = true;
            rust-analyzer = {
              enable = true;
              installRustc = false;
              installCargo = false;
            };
            html.enable = true;
            ccls.enable = true;
            cmake.enable = true;
            csharp-ls.enable = true;
            cssls.enable = true;
            gopls.enable = true;
            jsonls.enable = true;
            pyright.enable = true;
            tailwindcss.enable = true;
          };
        };
        lsp-lines.enable = true;
        treesitter = {
          enable = true;
          nixGrammars = true;
        };
        cmp = {
          enable = true;
          settings = {
          	enable = true;
          	autoEnableSources = true;
          	sources = [
          	  { name = "nvim_lsp"; }
          	  { name = "path"; }
          	  { name = "buffer"; }
          	];
          	mapping = {
          	  "<CR>" = "cmp.mapping.confirm({ select = true })";
          	  "<Tab>" = {
          	    action = ''cmp.mapping.select_next_item()'';
          	    modes = [ "i" "s" ];
          	  };
          	};
          };
        };
      };

      extraPlugins = [
        {
          plugin = pkgs.vimPlugins.lsp-inlayhints-nvim;
          config = ''
            lua require("lsp-inlayhints").setup()
          '';
        }
        pkgs.vimPlugins.telescope-file-browser-nvim
        {
          plugin = pkgs.vimPlugins.comment-nvim;
          config = "lua require(\"Comment\").setup()";
        }
      ];
      # FOR NEOVIDE
      extraConfigLua = ''
        vim.opt.guifont = "JetBrainsMono\\ NFM,Noto_Color_Emoji:h14"
        vim.g.neovide_cursor_animation_length = 0.05

        vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
        vim.api.nvim_create_autocmd("LspAttach", {
          group = "LspAttach_inlayhints",
          callback = function(args)
            if not (args.data and args.data.client_id) then
              return
            end

            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            require("lsp-inlayhints").on_attach(client, bufnr)
          end,
        })

        local colors = {
          blue   = '#${theme.base0D}',
          cyan   = '#${theme.base0C}',
          black  = '#${theme.base00}',
          white  = '#${theme.base05}',
          red    = '#${theme.base08}',
          violet = '#${theme.base0E}',
          grey   = '#${theme.base02}',
        }


        local bubbles_theme = {
          normal = {
            a = { fg = colors.black, bg = colors.violet },
            b = { fg = colors.white, bg = colors.grey },
            c = { fg = colors.black, bg = colors.black },
          },

          insert = { a = { fg = colors.black, bg = colors.blue } },
          visual = { a = { fg = colors.black, bg = colors.cyan } },
          replace = { a = { fg = colors.black, bg = colors.red } },

          inactive = {
            a = { fg = colors.white, bg = colors.black },
            b = { fg = colors.white, bg = colors.black },
            c = { fg = colors.black, bg = colors.black },
          },
        }

        require('lualine').setup {
          options = {
            theme = bubbles_theme,
            component_separators = '|',
            section_separators = { left = '', right = '' },
          },
          sections = {
            lualine_a = {
              { 'mode', separator = { left = '' }, right_padding = 2 },
            },
            lualine_b = { 'filename', 'branch' },
            lualine_c = { 'fileformat' },
            lualine_x = {},
            lualine_y = { 'filetype', 'progress' },
            lualine_z = {
              { 'location', separator = { right = '' }, left_padding = 2 },
            },
          },
          inactive_sections = {
            lualine_a = { 'filename' },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = { 'location' },
          },
          tabline = {},
          extensions = {},
        }
      '';

      extraConfigVim = ''
        set noshowmode
        inoremap jj <ESC>
      '';

      highlight = {
        Comment.fg = "#ff00ff";
        Comment.bg = "#000000";
        Comment.underline = true;
        Comment.bold = true;
      };

      keymaps = [
        # {
        #   mode = "n";
        #   key = "<space>fb";
        #   action = ":Telescope file_browser<CR>";
        #   options.noremap = true;
        # }
        {
          action = "<cmd>Telescope live_grep<CR>";
          key = "<leader>g";
        }
        {
          mode = "n";
          action = "<cmd>Telescope file_browser<CR>";
          key = "<leader>f";
          options.noremap = true;
        }
        {
          key = "<Tab>";
          action = ":bnext<CR>";
          options.silent = false;
        }
        {
          key = "<S-Tab>";
          action = ":bprev<CR>";
          options.silent = false;
        }
      ];
    };
  };
}
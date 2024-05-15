{ pkgs
, config
, lib
, inputs
, ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.xeta) disabled enabled list path optional;

  home = config.xeta.system.user.home;
  plugins = pkgs.vimPlugins;
  theme = lib.xeta.getTheme "tokyo-night-dark";

  treesitter-nu = (pkgs.tree-sitter.buildGrammar {
    language = "nu";
    version = "0.0.0+786689b";
    src = (pkgs.fetchFromGitHub {
      owner = "nushell";
      repo = "tree-sitter-nu";
      rev = "786689b0562b9799ce53e824cb45a1a2a04dc673";
      hash = "sha256-ENyK0l2KhhNfyuXCz0faLwVHMJjJxlRCqitJkJ8fD+w=";
    });
  });

  mkNeovimPlugin = inputs.nixvim.lib.${pkgs.system}.helpers.mkNeovimPlugin;
  buildVimPlugin = pkgs.vimUtils.buildVimPlugin;
  supermaven-nvim = (buildVimPlugin {
    pname = "supermaven-nvim";
    version = "2024-05-12";
    src = pkgs.fetchFromGitHub {
      owner = "supermaven-inc";
      repo = "supermaven-nvim";
      rev = "2d24b099c37c865e278a3e0b4f252770a04901c";
      hash = "sha256-WplJCb9JzBRwByVPRUFVZq3fKegNRjydM6HvSmxdShQ=";
    };
    meta.homepage = "https://github.com/supermaven-inc/supermaven-nvim";
  });

  themeLuaSource = ''
    local M = {}

    M.colors = {
      blue   = '#2AC3DE',
      cyan   = '#B4F9F8',
      black  = '#1A1B26',
      white  = '#A9B1D6',
      red    = '#C0CAF5',
      violet = '#BB9AF7',
      warn   = '#ebdbb2',
      grey   = '#2F3549',
      error  = '#b16286',
    }

    M.theme = {
      normal = {
        a = { fg = M.colors.black, bg = M.colors.violet },
        b = { fg = M.colors.white, bg = M.colors.grey },
        c = { fg = M.colors.black, bg = nil },
      },

      insert = { a = { fg = M.colors.black, bg = M.colors.blue } },
      visual = { a = { fg = M.colors.black, bg = M.colors.cyan } },
      replace = { a = { fg = M.colors.black, bg = M.colors.red } },

      inactive = {
        a = { fg = M.colors.white, bg = nil },
        b = { fg = M.colors.white, bg = nil },
        c = { fg = M.colors.black, bg = nil },
      },
    }

    return M
  '';

  cfg = config.xeta.nixvim;
in
{
  options.xeta.nixvim = {
    enable = mkEnableOption "Enable neovim config via nixvim.";
  };

  config = mkIf cfg.enable {
    snowfallorg.user.${config.xeta.system.user.username}.home.config = {
      home.file."/home/jules/.local/share/nvim/xeta/theme.lua".text = themeLuaSource;
      home.file."/home/jules/.local/share/nvim/xeta/extraConfig.lua".source = ./extraConfig.lua;
    };
    programs.nixvim = {
      enable = true;
      globals.mapleader = " "; # Sets the leader key to space
      filetype.extension.nu = "nu";

      opts = {
        clipboard = "unnamedplus";
        number = true;
        relativenumber = true;
        shiftwidth = 2;
        softtabstop = 2;
        tabstop = 2;
        smartindent = false;
        wrap = false;
        swapfile = false;
        backup = false;
        hlsearch = false;
        incsearch = true;
        termguicolors = true;
        scrolloff = 8;
        updatetime = 50;
      };

      colorschemes.tokyonight = {
        enable = true;
        settings = {
          style = "night";
          terminal_colors = true;
          transparent = true;
        };
      };

      plugins = {
        lsp-format = enabled;
        nix-develop = enabled;
        barbecue = enabled;
        rust-tools = enabled;
        harpoon = enabled;
        none-ls = enabled;
        ccc = enabled;
        gitsigns = enabled;
        smart-splits = enabled;
        telescope = {
          enable = true;
          keymaps = {
            "<leader>f" = "find_files";
            "<leader>g" = "live_grep";
          };
        };
        indent-blankline = enabled;
        improved-search = enabled;
        indent-o-matic = enabled;
        nvim-colorizer = enabled;
        nvim-autopairs = enabled;
        comment = enabled;
        lualine = enabled;
        lspkind = {
          enable = true;
          extraOptions = {
            cmp.enable = true;
          };
          mode = "symbol_text";
        };
        nix = enabled;
        crates-nvim = enabled;
        direnv = enabled;
        lazy = {
          enable = true;
        };
        lazygit = enabled;
        # codeium-nvim = enabled;
        obsidian = {
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
        ollama = {
          enable = true;
          action = "display_replace";
          model = "llama3";
          serve = {
            onStart = false;
          };
        };
        startup = {
          enable = true;
          theme = "dashboard";
        };
        rainbow-delimiters = enabled;
        better-escape = enabled;
        cmp-treesitter = enabled;
        cmp-fuzzy-buffer = enabled;
        cmp-fuzzy-path = enabled;
        cmp-cmdline = enabled;
        cmp-calc = enabled;
        cmp-nvim-lsp-document-symbol = enabled;
        cmp-nvim-lsp-signature-help = enabled;
        # cmp-vsnip = enabled;
        cmp_luasnip = enabled;
        coq-nvim = enabled;
        zellij = enabled;
        coq-thirdparty = enabled;
        transparent = enabled;
        luasnip = enabled;
        hop = enabled;
        lsp = {
          enable = true;
          servers = {
            lua-ls = {
              enable = true;
              settings = {
                telemetry = disabled;
              };
            };
            nushell = enabled;
            tsserver = enabled;
            htmx = enabled;
            zls = enabled;
            rnix-lsp = enabled;
            bashls = enabled;
            rust-analyzer = {
              enable = true;
              installRustc = false;
              installCargo = false;
            };
            html = enabled;
            ccls = enabled;
            cmake = enabled;
            csharp-ls = enabled;
            cssls = enabled;
            gopls = enabled;
            jsonls = enabled;
            pyright = enabled;
            tailwindcss = enabled;
          };
        };
        lsp-lines = enabled;
        treesitter = {
          enable = true;
          nixGrammars = true;
          indent = true;
          languageRegister.nu = "nu";
          parserInstallDir = "${home}/.local/share/treesitter/parsers";
          grammarPackages = plugins.nvim-treesitter.passthru.allGrammars ++ [
            treesitter-nu
          ];
        };
        cmp = {
          enable = true;
          settings = {
            enable = true;
            autoEnableSources = true;
            snippet.expand = ''
              function(args)
                -- vim.fn["vsnip#anonymous"](args.body)
                require('luasnip').lsp_expand(args.body)
              end
            '';
            sources = [
              { name = "nvim_lsp"; }
              { name = "nvim_lsp_document_symbol"; }
              { name = "nvim_lsp_signature_help"; }
              # { name = "codeium"; }
              { name = "path"; }
              { name = "buffer"; }
              { name = "calc"; }
            ];
            mapping = {
              "<C-b>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-e>" = "cmp.mapping.close()";
              "<C-p>" = "cmp.mapping.select_prev_item()";
              "<C-n>" = "cmp.mapping.select_next_item()";
              "<CR>" = ''
                cmp.mapping.confirm({
                  behavior = cmp.ConfirmBehavior.Insert,
                  select = true,
                })
              '';
              "<Tab>" = ''
                cmp.mapping(function(fallback)
                  local supermaven = require("supermaven-nvim.completion_preview")
                  local inlay_instance = supermaven.inlay_instance
                  local accept_cmp = function()

                  end

                  if supermaven.inlay_instance ~= nil then
                    supermaven:accept_completion_text()
                  else

                  end

                  if cmp.visible() then
                    cmp.select_next_item()
                  else
                    fallback()
                  end
                end, {'i', 's'})
              '';
              "<S-Tab>" = ''
                cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  else
                    fallback()
                  end
                end, {'i', 's'})
              '';
            };
          };
        };
      };

      extraPlugins = [
        {
          plugin = plugins.nvim-nu;
          config = "lua require('nu').setup()";
        }
        pkgs.xeta.supermaven-nvim
        plugins.vim-vsnip
        plugins.fzf-vim
        plugins.ai-vim
        plugins.telescope-file-browser-nvim
      ];

      extraFiles = {
        "queries/nu/highlights.scm" = builtins.readFile "${treesitter-nu}/queries/highlights.scm";
        "queries/nu/injections.scm" = builtins.readFile "${treesitter-nu}/queries/injections.scm";
      };

      extraConfigLua =
        let
          extraConfigPath = path.fromString "/home/jules/000_dev/000_config/010_minimal-hyprland-flake/flake-src/modules/nixos/neovim/extraConfig.lua";
          extraConfigLua = builtins.readFile (extraConfigPath.value);
        in
        (lib.concatStringsSep "\n" [
          "vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/xeta')" # ~/.local/share/nvim/xeta
          "package.path = package.path .. ';' .. vim.fn.stdpath('data') .. '/xeta/?.lua'"
          "local theme_module = require('theme')"
          "local colors = theme_module.colors"
          "local theme = theme_module.theme"
          extraConfigLua
        ]);

      extraConfigVim = ''
        set noshowmode
        inoremap jj <ESC>

        hi Normal guibg=NONE ctermbg=NONE
        hi LineNr guibg=NONE ctermbg=NONE
        hi SignColumn guibg=NONE ctermbg=NONE

        command! CloseAndDelete call ConfirmDelete()

        function ConfirmDelete()
          if confirm("Are you sure you want to delete this file?", "&Yes\n&No", 2) == 1
            call delete(expand('%'))
            bd
          endif
        endfunction
      '';

      keymaps = [
        {
          key = "<leader>lg";
          action = "<cmd>LazyGit<CR>";
          options = {
            desc = "Open LazyGit inside Vim";
            noremap = true;
            silent = true;
          };
        }
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
          key = "<leader>n";
          action = "<cmd>enew<CR>";
          options = {
            noremap = true;
            silent = true;
            desc = "Create a new empty buffer";
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
          action = "require('lsp_lines').toggle";
          lua = true;
          key = "<leader>l";
          options = {
            desc = "Toggle LSP virtual line diagnostics";
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
          action = "<cmd>vim.lsp.buf.declaration<CR>";
          key = "gD";
          options = { noremap = true; desc = "Go to declaration"; };
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
          action = "vim.lsp.buf.code_action";
          key = "<leader>ca";
          options = { noremap = true; desc = "See available code actions"; };
        }
        {
          action = "vim.lsp.buf.rename";
          key = "<leader>rn";
          options = { noremap = true; desc = "Smart rename"; };
        }
        {
          action = "<cmd>Telescope diagnostics bufnr=0<CR>";
          key = "<leader>D";
          options = { noremap = true; desc = "Show buffer diagnostics"; };
        }
        {
          action = "<cmd>vim.diagnostic.open_float<CR>";
          key = "<leader>d";
          options = { noremap = true; desc = "Show line diagnostics"; };
        }
        {
          action = "<cmd>vim.diagnostic.goto_prev<CR>";
          key = "[d";
          options = { noremap = true; desc = "Go to previous diagnostic"; };
        }
        {
          action = "<cmd>vim.diagnostic.goto_next<CR>";
          key = "]d";
          options = { noremap = true; desc = "Go to next diagnostic"; };
        }
        {
          action = "<cmd>vim.lsp.buf.hover<CR>";
          key = "K";
          options = { noremap = true; desc = "Show documentation for what is under cursor"; };
        }
        {
          action = "<cmd>LspRestart<CR>";
          key = "<leader>rs";
          options = { noremap = true; desc = "Restart LSP"; };
        }
        {
          action = "<cmd>bnext<CR>";
          key = "<Tab>";
          options.silent = false;
        }
        {
          action = "<cmd>bprev<CR>";
          key = "<S-Tab>";
          options.silent = false;
        }
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
        {
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
        }
      ];

      highlight = {
        Comment.fg = "#ff00ff";
        Comment.bg = "#000000";
        Comment.underline = true;
        Comment.bold = true;
      };
    };
  };
}


{ pkgs
, config
, lib
, inputs
, ...
}:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.xeta) disabled enabled list path optional mkOpt;

  cfg = config.xeta.nixvim.plugins.lsp;
in
{
  options.xeta.nixvim.plugins.lsp = {
    enable = mkEnableOption "Enable LSP configuration and plugins.";
  };

  config = mkIf cfg.enable
    {
      programs.nixvim = {
        plugins = {
          luasnip = enabled;
          rainbow-delimiters = enabled;
          better-escape = enabled;
          indent-blankline = enabled;
          improved-search = enabled;
          indent-o-matic = enabled;
          nvim-colorizer = enabled;
          nvim-autopairs = enabled;
          comment = enabled;
          nix = enabled;
          crates-nvim = enabled;
          direnv = enabled;
          lsp-lines = enabled;
          lsp-format = enabled;
          nix-develop = enabled;

          lspkind = {
            enable = true;
            extraOptions = {
              cmp.enable = true;
            };
            mode = "symbol_text";
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
        };

        keymaps = [
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
        ];
      };
    };
}

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

  cfg = config.xeta.nixvim.plugins.cmp;
in
{
  options.xeta.nixvim.plugins.cmp = {
    enable = mkEnableOption "enable cmp";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins = {
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
        coq-thirdparty = enabled;

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
              { name = "path"; }
              # { name = "buffer"; }
              { name = "calc"; }
            ];

            completion = { };

            mapping = {
              "<C-b>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-c>" = "cmp.mapping.abort()";

              "<C-p>" = "cmp.mapping.select_prev_item()";
              "<C-n>" = "cmp.mapping.select_next_item()";
              "<Up>" = "cmp.mapping.select_prev_item()";
              "<Down>" = "cmp.mapping.select_next_item()";

              "<CR>" = ''
                cmp.mapping.confirm({
                  behavior = cmp.ConfirmBehavior.Replace,
                  select = true,
                })
              '';

              "<Esc>" = ''
                cmp.mapping(function(fallback)
                  local completion = require('supermaven-nvim.completion_preview')

                  if cmp.visible() then
                    cmp.abort()
                  end

                  if completion.inlay_instance ~= nil then
                    completion.on_dispose_inlay()
                  end

                  fallback()
                end, {'i', 's'})
              '';

              "<Tab>" = ''
                cmp.mapping(function(fallback)
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

            cmdline = {
              "/" = {
                mapping = {
                  __raw = "cmp.mapping.preset.cmdline()";
                };
                sources = [
                  {
                    name = "buffer";
                  }
                ];
              };
              ":" = {
                mapping = {
                  __raw = "cmp.mapping.preset.cmdline()";
                };
                sources = [
                  {
                    name = "path";
                  }
                  {
                    name = "cmdline";
                    option = {
                      ignore_cmds = [
                        "Man"
                        "!"
                      ];
                    };
                  }
                ];
              };
            };
          };
        };
      };
    };
  };
}

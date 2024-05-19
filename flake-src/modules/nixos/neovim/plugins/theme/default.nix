{ pkgs
, config
, lib
, inputs
, ...
}:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.xeta) disabled enabled list path optional mkOpt;
  inherit (pkgs.xeta) treesitter-nu supermaven-nvim;

  home = config.xeta.system.user.home;
  plugins = pkgs.vimPlugins;
  theme = lib.xeta.getTheme "tokyo-night-dark";

  cfg = config.xeta.nixvim.plugins.theme;
in
{
  options.xeta.nixvim.plugins.theme = {
    enable = mkEnableOption "Enable theme related config via nixvim.";
  };

  config = mkIf cfg.enable {
    snowfallorg.user.${config.xeta.system.user.username}.home.config = {
      home.file."/home/jules/.local/share/nvim/xeta/theme.lua".text = with theme; ''
        local M = {}

        M.colors = {
          blue = '#${base08}',
          cyan = '#${base0C}',
          black = '#${base01}',
          white = '#${base06}',
          red = '#${base0F}',
          violet = '#${base0E}',
          warning = '#${base0A}',
          grey = '#${base04}',
          error = '#${base03}',
          success = '#${base0B}',
          info = '#${base0D}',
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
            c = { fg = M.colors.white, bg = nil },
          },
        }

        return M
      '';

    };

    programs.nixvim = {
      colorschemes.tokyonight = {
        enable = true;
        settings = {
          style = "night";
          terminal_colors = true;
          transparent = true;
        };
      };

      highlight = with theme; {
        Comment.fg = "#${base0F}";
        Comment.bg = "#${base01}";
        Comment.underline = true;
        Comment.bold = true;

        VirtText.fg = "#${base0F}";
        VirtText.bg = "#${base01}";

        RainbowDelimiterRed.fg = "#${base08}";
        RainbowDelimiterRed.bg = "NONE";
        RainbowDelimiterYellow.fg = "#${base0A}";
        RainbowDelimiterYellow.bg = "NONE";
        RainbowDelimiterBlue.fg = "#${base0D}";
        RainbowDelimiterBlue.bg = "NONE";
        RainbowDelimiterOrange.fg = "#${base09}";
        RainbowDelimiterOrange.bg = "NONE";
        RainbowDelimiterGreen.fg = "#${base0B}";
        RainbowDelimiterGreen.bg = "NONE";
        RainbowDelimiterViolet.fg = "#${base0E}";
        RainbowDelimiterViolet.bg = "NONE";
        RainbowDelimiterCyan.fg = "#${base0C}";
        RainbowDelimiterCyan.bg = "NONE";
      };
    };
  };
}

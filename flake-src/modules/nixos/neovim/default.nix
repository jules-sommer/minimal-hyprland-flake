{ pkgs
, config
, lib
, ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.xeta) enabled path;
  inherit (pkgs.xeta) supermaven-nvim;

  plugins = pkgs.vimPlugins;

  cfg = config.xeta.nixvim;
in
{
  options.xeta.nixvim = {
    enable = mkEnableOption "Enable neovim config via nixvim.";
  };

  config = mkIf cfg.enable {
    snowfallorg.user.${config.xeta.system.user.username}.home.config = {
      # this just allows us to put our init/extraConfig.lua in a separate file
      home.file."/home/jules/.local/share/nvim/xeta/extraConfig.lua".source = ./extraConfig.lua;
    };

    programs.nixvim = {
      enable = true;
      globals.mapleader = " ";
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

      plugins = {
        barbecue = enabled;
        rust-tools = enabled;
        rainbow-delimiters = enabled;
        better-escape = enabled;
        harpoon = enabled;
        ccc = enabled;
        gitsigns = enabled;
        lualine = enabled;
        noice = enabled;
        notify = enabled;
        lazy = {
          enable = true;
        };
        lazygit = enabled;
        transparent = enabled;
        zellij = enabled;
      };

      extraPlugins = [
        {
          plugin = plugins.nvim-nu;
          config = "lua require('nu').setup()";
        }
        plugins.zoxide-vim
        supermaven-nvim
        plugins.vim-vsnip
        plugins.fzf-vim
        plugins.ai-vim
        plugins.telescope-file-browser-nvim
      ];

      extraConfigLua =
        let
          extraConfigPath = path.fromString "/home/jules/000_dev/000_config/010_minimal-hyprland-flake/flake-src/modules/nixos/neovim/extraConfig.lua";
          extraConfigLua = builtins.readFile (extraConfigPath.value);
        in
        (lib.concatStringsSep "\n" [
          "vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/xeta')" # ~/.local/share/nvim/xeta
          "package.path = package.path .. ';' .. vim.fn.stdpath('data') .. '/xeta/?.lua'"
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
          key = "<leader>n";
          action = "<cmd>enew<CR>";
          options = {
            noremap = true;
            silent = true;
            desc = "Create a new empty buffer";
          };
        }
        {
          action = "<cmd>bnext<CR>";
          key = "<Tab>";
          mode = [ "n" ];
          options.silent = false;
        }
        {
          action = "<cmd>bprev<CR>";
          key = "<S-Tab>";
          mode = [ "n" ];
          options.silent = false;
        }
      ];
    };
  };
}

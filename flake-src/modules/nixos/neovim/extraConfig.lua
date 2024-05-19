local theme_module = require('theme')
local colors = theme_module.colors
local theme = theme_module.theme

vim.opt.guifont = "JetBrainsMono\\ NFM,Noto_Color_Emoji:h14"
vim.g.neovide_cursor_animation_length = 0.05

require("supermaven-nvim").setup({
  ignore_filetypes = {
    help = true,
    startify = true,
    dashboard = true,
    packer = true,
    neogitstatus = true,
    NvimTree = true,
    Trouble = true,
    alpha = true,
    lir = true,
    Outline = true,
    aerial = true,
    spectre_panel = true,
    toggleterm = true,
    qf = true,
    dapui_hover = true,
    TelescopePrompt = true,
  },
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.nu = {
  filetype = "nu",
}

vim.diagnostic.config({
  virtual_text = false,
})

vim.opt.timeoutlen = 300

require("rust-tools").setup({
  tools = {
    inlay_hints = {
      auto = false
    }
  }
})

vim.lsp.inlay_hint.enable(true)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end
})

require("cmp").setup({
  formatting = {
    format = require('lspkind').cmp_format({
      mode = "symbol",
      maxwidth = 50,
      ellipsis_char = '...',
      symbol_map = { Codeium = "", }
    })
  }
})

-- Define a function to check that ollama is installed and working
local function get_condition()
  return package.loaded["ollama"] and require("ollama").status ~= nil
end

-- Define a function to check the status and return the corresponding icon
local function get_status_icon()
  local status = require("ollama").status()

  if status == "IDLE" then
    return " IDLE"
  elseif status == "WORKING" then
    return " BUSY"
  end
end

require('lualine').setup {
  options = {
    theme = theme,
    component_separators = '|',
    section_separators = { left = '', right = '' },
  },

  sections = {
    lualine_a = {
      {
        'mode',
        separator = { left = '' },
        right_padding = 5,
      }
    },
    lualine_b = {
      'branch',
      'diff',
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ' },
        color = { fg = colors.warn, bg = colors.cyan }
      }
    },
    lualine_c = {
      {
        'filename',
        file_status = true,
        path = 1
      }
    },
    lualine_x = {
      'encoding',
      'fileformat',
      get_status_icon,
    },
    lualine_y = {
      'filetype',
      'progress'
    },
    lualine_z = {
      {
        'location',
        separator = { right = '' },
        left_padding = 5
      }
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

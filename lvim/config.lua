-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- Instalação do LSP para Python
lvim.lsp.installer.setup.ensure_installed = {
    "pyright"
}

-- Plugins adicionais
lvim.plugins = {
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/nvim-compe" },
    { "catppuccin/nvim", name = "catppuccin" },
    { "github/copilot.vim" }
}

-- Configuração do Treesitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "python" },
    highlight = {
        enable = true,
    },
}

-- Configuração do Compe para autocompletação
vim.o.completeopt = "menuone,noselect"
require'compe'.setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = 'enable',
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,

    source = {
        path = true,
        buffer = true,
        calc = true,
        nvim_lsp = true,
        nvim_lua = true,
        vsnip = true,
        ultisnips = true,
        luasnip = true,
    },
}

-- Configuração do nvim-dap para depuração
local dap = require('dap')

dap.adapters.python = {
  type = 'executable';
  command = 'python';
  args = { '-m', 'debugpy.adapter' };
}

dap.configurations.python = {
  {
    type = 'python';
    request = 'launch';
    name = "Launch file";
    program = "${file}";
    pythonPath = function()
      return '/usr/bin/python'
    end;
  },
}

-- Configuração do Ruff para formatação e linting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "ruff", filetypes = { "python" } },
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "ruff", filetypes = { "python" } },
}

-- Configuração do Tema Catppuccin
vim.g.catppuccin_flavour = "mocha"
require("catppuccin").setup()

-- Ativando o tema
vim.cmd[[colorscheme catppuccin]]

-- Configuração do GitHub Copilot
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- Opcional: Desabilitar Copilot para arquivos específicos
vim.g.copilot_filetypes = {
    ["*"] = true,
    ["markdown"] = false,
    ["text"] = false,
}


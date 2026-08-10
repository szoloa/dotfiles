-- init.lua

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.completeopt = {'menuone', 'noselect'}
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.o.termguicolors = true
vim.g.mapleader = ' '

vim.api.nvim_set_keymap('n', 'j', [[v:count ? 'j' : 'gj']], { noremap = true, expr = true })
vim.api.nvim_set_keymap('n', 'k', [[v:count ? 'k' : 'gk']], { noremap = true, expr = true })

vim.api.nvim_set_keymap('n', '0', 'g0', { noremap = true })
vim.api.nvim_set_keymap('n', '$', 'g$', { noremap = true })
vim.api.nvim_set_keymap('n', '^', 'g^', { noremap = true })

vim.pack.add({
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/saghen/blink.lib',
    'https://github.com/saghen/blink.cmp',
    'https://github.com/folke/tokyonight.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/keaising/im-select.nvim',
    'https://github.com/startup-nvim/startup.nvim',
	'https://github.com/brenton-leighton/multiple-cursors.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-mini/mini.nvim',            -- if you use the mini.nvim suite
    -- 'https://github.com/nvim-mini/mini.icons',        -- if you use standalone mini plugins
    -- 'https://github.com/nvim-tree/nvim-web-devicons', -- if you prefer nvim-web-devicons
    -- 'https://github.com/MeanderingProgrammer/render-markdown.nvim',
    'https://github.com/AuroBreeze/quick-c'
})

-- require('render-markdown').setup({}) -- only mandatory if you want to set custom options

local cmp = require("blink.cmp")
cmp.build():wait(60000)
cmp.setup()

require('telescope').setup()
require('im_select').setup()
require('startup').setup({theme = 'dashboard'})
require('multiple-cursors').setup({
	keys = {
		{"<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "x"}},
		{"<C-k>", "<Cmd>MultipleCursorsAddup<CR>", mode = {"n", "x"}},

		{"<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "x"}},
		{"<C-Up>", "<Cmd>MultipleCursorsAddup<CR>", mode = {"n", "x"}},
	}
})
require("mason").setup()
require("quick-c").setup()

vim.cmd[[colorscheme tokyonight]]

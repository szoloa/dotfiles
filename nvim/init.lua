-- init.lua

-- Options
vim.opt.number = true
-- vim.opt.relativenumber = true
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
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- -- spell checking and auto wrap
-- vim.opt.wrap = true 
-- vim.opt.spell = true 
--
-- Keymaps
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = ' '

-- Normal mode mappings
map('n', '<leader>pv', ':NvimTreeToggle<CR>', opts)

-- Packer setup
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Packer plugins
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Colorscheme
  use 'folke/tokyonight.nvim'

  -- Statusline
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- File explorer
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons'
  }

  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- LSP
  use 'neovim/nvim-lspconfig'

  -- Autocompletion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip'
  use 'junegunn/fzf.vim'
  use {
  "startup-nvim/startup.nvim",
  requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim"},
  config = function()
    require"startup".setup()
  end
}
end)

-- Colorscheme setup
vim.cmd[[colorscheme tokyonight]]



-- Lualine setup
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
  },
}

-- NvimTree setup
require('nvim-tree').setup()

-- Telescope setup
-- local telescope = require('telescope.builtin')
-- map('n', '<leader>ff', telescope.find_files, opts)
-- map('n', '<leader>fg', telescope.live_grep, opts)
-- map('n', '<leader>fb', telescope.buffers, opts)
-- map('n', '<leader>fh', telescope.help_tags, opts)

-- LSP and Autocompletion setup will be more involved and might require separate files
-- For now, this is a good starting point.

local Plug = vim.fn['plug#']

-- Plugin installation
vim.call('plug#begin')

-- use a release tag to download pre-built binaries.
-- To build from source, use { ['do'] = 'cargo build --release' } instead
-- If you use nix, use { ['do'] = 'nix run .#build-plugin' }
Plug('saghen/blink.cmp', { ['tag'] = 'v1.*' })

-- optional: provides snippets for the snippet source
Plug('rafamadriz/friendly-snippets')

Plug('nvim-treesitter/nvim-treesitter')

Plug('mason-org/mason.nvim')
Plug('keaising/im-select.nvim')
Plug('junegunn/fzf.vim')
Plug("nvim-telescope/telescope.nvim")
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope-file-browser.nvim")

Plug('startup-nvim/startup.nvim')

vim.call('plug#end')

-- Plugin configuration
require('blink.cmp').setup({
  keymap = { preset = 'default', 
    ['<Enter>'] = { 'select_and_accept', 'fallback' },
    -- ['<Tab>'] = { 'select_next', 'fallback' },
  },
  appearance = {
    nerd_font_variant = 'mono'
  },

  completion = {
    documentation = { auto_show = false }
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  fuzzy = {
    implementation = "prefer_rust_with_warning"
  }
})

require('nvim-treesitter').setup()
-- require('nvim-treesitter').install({'rust', 'c', 'python'}):wait(30000)
require("mason").setup()
require("im_select").setup()
require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key"
      }
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}

require("startup").setup({theme = "dashboard"}) -- put theme name here

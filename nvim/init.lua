-- init.lua
-- init.lua

-- 避免 startup.nvim 的仪表盘回调修改 kitty-scrollback 的临时缓冲区
if vim.env.KITTY_SCROLLBACK_NVIM == 'true' then
    vim.g.startup_disable_on_startup = true
end

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
-- vim.opt.termguicolors = true
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
-- vim.g.mapleader = ' '
vim.opt.fileencodings = { "ucs-bom", "utf-8", "gbk", "gb18030", "big5", "latin1" }

vim.api.nvim_set_keymap('n', 'j', [[v:count ? 'j' : 'gj']], { noremap = true, expr = true })
vim.api.nvim_set_keymap('n', 'k', [[v:count ? 'k' : 'gk']], { noremap = true, expr = true })

vim.api.nvim_set_keymap('n', '0', 'g0', { noremap = true })
vim.api.nvim_set_keymap('n', '$', 'g$', { noremap = true })
vim.api.nvim_set_keymap('n', '^', 'g^', { noremap = true })

vim.pack.add({
    'https://github.com/neovim/nvim-lspconfig',
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
    'https://github.com/AuroBreeze/quick-c', 
    'https://github.com/selimacerbas/live-server.nvim',
    'https://github.com/selimacerbas/markdown-preview.nvim',
    'https://github.com/HakonHarnes/img-clip.nvim',
    'https://github.com/R-nvim/R.nvim',
})

-- require('render-markdown').setup({}) -- only mandatory if you want to set custom options

local cmp = require("blink.cmp")
cmp.build():wait(60000)
cmp.setup()

require('telescope').setup()
require('im_select').setup()
-- require('startup').setup({theme = 'dashboard'})

require('nvim-treesitter').install( { "markdown", "markdown_inline", "r", "rnoweb", "yaml", "latex", "csv", "typst" }) :wait(300000) 

require('multiple-cursors').setup({
	keys = {
		{"<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "x"}},
		{"<C-k>", "<Cmd>MultipleCursorsAddup<CR>", mode = {"n", "x"}},

		{"<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "x"}},
		{"<C-Up>", "<Cmd>MultipleCursorsAddup<CR>", mode = {"n", "x"}},
	}
})

local function mc(cmd)
  return '<Cmd>' .. cmd .. '<CR>'
end

vim.keymap.set({'n', 'x'}, '<C-j>', mc('MultipleCursorsAddDown'),
  { desc = 'Add cursor and move down' })
vim.keymap.set({'n', 'x'}, '<C-k>', mc('MultipleCursorsAddUp'),
  { desc = 'Add cursor and move up' })

vim.keymap.set({'n', 'i', 'x'}, '<C-Down>', mc('MultipleCursorsAddDown'),
  { desc = 'Add cursor and move down' })
vim.keymap.set({'n', 'i', 'x'}, '<C-Up>', mc('MultipleCursorsAddUp'),
  { desc = 'Add cursor and move up' })

-- 把光标放到单词上，给所有匹配项加光标
vim.keymap.set({'n', 'x'}, '<Leader>a', mc('MultipleCursorsAddMatches'),
  { desc = 'Add cursors to cword' })
-- 加一个光标并跳到下一个匹配
vim.keymap.set({'n', 'x'}, '<Leader>d', mc('MultipleCursorsAddJumpNextMatch'),
  { desc = 'Add cursor and jump to next match' })
-- 视觉模式下按行批量加光标
vim.keymap.set('x', '<Leader>m', mc('MultipleCursorsAddVisualArea'),
  { desc = 'Add cursors to lines of visual area' })
-- 鼠标 Ctrl+点击 加/删光标
vim.keymap.set({'n', 'i'}, '<C-LeftMouse>', mc('MultipleCursorsMouseAddDelete'),
  { desc = 'Add or remove cursor on click' })

require("mason").setup()
require("quick-c").setup()

require("markdown_preview").setup({
      -- all optional; sane defaults shown
      instance_mode = "takeover",  -- "takeover" (one tab) or "multi" (tab per instance)
      port = 0,                    -- 0 = auto (8421 for takeover, OS-assigned for multi)
      open_browser = true,
      default_theme = "dark",      -- "dark" or "light"; initial preview theme
      debounce_ms = 300,
})

require("img-clip").setup({
    default = { dir_path = "images", } 
})

require("r").setup()

vim.cmd[[colorscheme tokyonight]]

-- 创建一个自动命令组，便于管理
local augroup = vim.api.nvim_create_augroup("RestoreCursor", { clear = true })

-- 创建自动命令
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    pattern = "*",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"') -- 获取文件标记 '"' 的位置
        local lnum = mark[1]
        local col = mark[2]
        -- 检查位置是否有效（行号大于0且不超过文件总行数）
        if lnum > 0 and lnum <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, { lnum, col })
        end
    end
})


-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
-- vim.opt.termguicolors = true
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
-- vim.g.mapleader = ' '
vim.opt.fileencodings = { "ucs-bom", "utf-8", "gbk", "gb18030", "big5", "latin1" }

vim.api.nvim_set_keymap('n', 'j', [[v:count ? 'j' : 'gj']], { noremap = true, expr = true })
vim.api.nvim_set_keymap('n', 'k', [[v:count ? 'k' : 'gk']], { noremap = true, expr = true })

vim.api.nvim_set_keymap('n', '0', 'g0', { noremap = true })
vim.api.nvim_set_keymap('n', '$', 'g$', { noremap = true })
vim.api.nvim_set_keymap('n', '^', 'g^', { noremap = true })

vim.pack.add({
    'https://github.com/neovim/nvim-lspconfig',
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
    'https://github.com/AuroBreeze/quick-c', 
    'https://github.com/selimacerbas/live-server.nvim',
    'https://github.com/selimacerbas/markdown-preview.nvim',
    'https://github.com/HakonHarnes/img-clip.nvim',
    'https://github.com/R-nvim/R.nvim',
    'https://github.com/kevinhwang91/nvim-ufo',
    'https://github.com/kevinhwang91/promise-async',
    'https://github.com/mikesmithgh/kitty-scrollback.nvim'
})

-- .nomedia
-- .nomedia
-- .nomedia

-- require('render-markdown').setup({}) -- only mandatory if you want to set custom options

cmp = require("blink.cmp")
cmp.build():wait(60000)
cmp.setup()

require('telescope').setup()
require('im_select').setup()
require('startup').setup({theme = 'dashboard'})
require('kitty-scrollback').setup()

-- require('ufo').setup({provider_selector = function(bufnr, filetype, buftype)
        -- return {'treesitter', 'indent'}
    -- end})

require('nvim-treesitter').install( { "markdown", "markdown_inline", "r", "rnoweb", "yaml", "latex", "csv", "typst", "rust" }) :wait(300000) 

require('multiple-cursors').setup({
	keys = {
		{"<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "x"}},
		{"<C-k>", "<Cmd>MultipleCursorsAddup<CR>", mode = {"n", "x"}},

		{"<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "x"}},
		{"<C-Up>", "<Cmd>MultipleCursorsAddup<CR>", mode = {"n", "x"}},
	}
})

local function mc(cmd)
  return '<Cmd>' .. cmd .. '<CR>'
end

vim.keymap.set({'n', 'x'}, '<C-j>', mc('MultipleCursorsAddDown'),
  { desc = 'Add cursor and move down' })
vim.keymap.set({'n', 'x'}, '<C-k>', mc('MultipleCursorsAddUp'),
  { desc = 'Add cursor and move up' })

vim.keymap.set({'n', 'i', 'x'}, '<C-Down>', mc('MultipleCursorsAddDown'),
  { desc = 'Add cursor and move down' })
vim.keymap.set({'n', 'i', 'x'}, '<C-Up>', mc('MultipleCursorsAddUp'),
  { desc = 'Add cursor and move up' })

-- 把光标放到单词上，给所有匹配项加光标
vim.keymap.set({'n', 'x'}, '<Leader>a', mc('MultipleCursorsAddMatches'),
  { desc = 'Add cursors to cword' })
-- 加一个光标并跳到下一个匹配
vim.keymap.set({'n', 'x'}, '<Leader>d', mc('MultipleCursorsAddJumpNextMatch'),
  { desc = 'Add cursor and jump to next match' })
-- 视觉模式下按行批量加光标
vim.keymap.set('x', '<Leader>m', mc('MultipleCursorsAddVisualArea'),
  { desc = 'Add cursors to lines of visual area' })
-- 鼠标 Ctrl+点击 加/删光标
vim.keymap.set({'n', 'i'}, '<C-LeftMouse>', mc('MultipleCursorsMouseAddDelete'),
  { desc = 'Add or remove cursor on click' })

require("mason").setup()
require("quick-c").setup()

require("markdown_preview").setup({
      -- all optional; sane defaults shown
      instance_mode = "takeover",  -- "takeover" (one tab) or "multi" (tab per instance)
      port = 0,                    -- 0 = auto (8421 for takeover, OS-assigned for multi)
      open_browser = true,
      default_theme = "dark",      -- "dark" or "light"; initial preview theme
      debounce_ms = 300,
})

require("img-clip").setup({
    default = { dir_path = "images", } 
})

require("r").setup()

vim.cmd[[colorscheme tokyonight]]

-- 创建一个自动命令组，便于管理
local augroup = vim.api.nvim_create_augroup("RestoreCursor", { clear = true })

-- 创建自动命令
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    pattern = "*",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"') -- 获取文件标记 '"' 的位置
        local lnum = mark[1]
        local col = mark[2]
        -- 检查位置是否有效（行号大于0且不超过文件总行数）
        if lnum > 0 and lnum <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, { lnum, col })
        end
    end
})


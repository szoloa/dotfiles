-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.diagnostic.config({
      virtual_text = false, -- 关闭行尾的错误信息
      -- underline = true,   -- 如果希望保留错误下划线就取消这里的注释
      -- signs = true        -- 如果希望保留侧边栏错误图标就取消这里的注释
    })
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst", -- 模式: 针对 markdown 文件
  callback = function()
    vim.opt_local.spell = false -- 为这些文件类型设置本地的 spell 选项为 false
  end,
})

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false, -- 关闭行尾的错误信息
        underline = true, -- 如果你想关闭下划线，可以改成 false
        signs = true, -- 保留侧边栏的错误图标
      },
    },
  },
}

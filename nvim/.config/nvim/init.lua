-- packer.nvim uses vim.tbl_islist which is deprecated in Neovim 0.10+
-- Silently redirect to the replacement before packer loads
vim.tbl_islist = vim.islist

require("romani")


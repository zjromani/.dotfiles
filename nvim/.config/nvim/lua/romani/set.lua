-- block in normal/visual, beam in insert, horizontal bar in replace
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25-blinkwait300-blinkon200-blinkoff150,r-cr:hor20,o:hor50"

vim.opt.nu = true
vim.opt.relativenumber = false

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- markdown-preview: light theme + prose CSS (larger type, open leading, ~65ch measure)
vim.g.mkdp_theme = 'light'
vim.g.mkdp_markdown_css = vim.fn.expand("~/.config/nvim/css/markdown-preview.css")

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = "*",
  callback = function()
    if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! write")
    end
  end,
})


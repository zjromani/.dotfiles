vim.g.mapleader = ","
vim.keymap.set("n", "<leader><leader>v", vim.cmd.Ex)
vim.keymap.set("n", "<space>", "viw")
vim.keymap.set("n", "-", "ddkP")
vim.keymap.set("n", "_", "ddp")

vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")


vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


-- udpate current file to be exucutable
vim.keymap.set("n", "<leader>x", "<cmd>silent !chmod +x %<CR>")

-- add things to system clipboard :)
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<C-n>", "<cmd>silent !tmux neww<CR>")
vim.keymap.set("n", "<leader>cs", "<cmd>let @*=expand('%')<CR>")


vim.keymap.set("v", "H", "^")
vim.keymap.set("v", "L", "$")
vim.keymap.set("v", "J", ":<C-u>silent! '<,'>m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":<C-u>silent! '<,'>m '<-2<CR>gv=gv")

vim.keymap.set("i", "jk", "<Esc>")

-- macOS-style word movement in insert mode (Option+arrows)
vim.keymap.set("i", "<M-Right>", "<C-o>w")
vim.keymap.set("i", "<M-Left>", "<C-o>b")

-- macOS-style word selection from insert mode (Option+Shift+arrows → visual mode)
vim.keymap.set("i", "<M-S-Right>", "<Esc>lvw")
vim.keymap.set("i", "<M-S-Left>", "<Esc>vb")

-- Shift+arrows: character selection from normal mode
vim.keymap.set("n", "<S-Right>", "v<Right>")
vim.keymap.set("n", "<S-Left>", "v<Left>")
vim.keymap.set("n", "<S-Up>", "v<Up>")
vim.keymap.set("n", "<S-Down>", "v<Down>")

-- Option+Shift+arrows: word selection from normal mode
vim.keymap.set("n", "<M-S-Right>", "vw")
vim.keymap.set("n", "<M-S-Left>", "vb")

-- Extend selection in visual mode
vim.keymap.set("v", "<S-Right>", "<Right>")
vim.keymap.set("v", "<S-Left>", "<Left>")
vim.keymap.set("v", "<M-S-Right>", "w")
vim.keymap.set("v", "<M-S-Left>", "b")

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
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("i", "jk", "<Esc>")

vim.keymap.set("n", "<leader>cc",  ':CopilotChat ', { remap=false })
vim.keymap.set("x", "<leader>cc",  ':CopilotChatVisual ', { remap=false })
vim.keymap.set("n", "<leader>ccb",  ':CopilotChatBuffer ', { remap=false })
vim.keymap.set("x", "<leader>ccx",  ':CopilotChatInPlace<CR>', { remap=false })

-- telescope
local ccca = require("CopilotChat.code_actions")
vim.keymap.set("n", "<leader>cch",  function() ccca.show_help_actions() end, { remap=false })
vim.keymap.set("n", "<leader>ccp",  function() ccca.show_prompt_actions() end, { remap=false })
vim.keymap.set("x", "<leader>ccp",  function() ccca.show_prompt_actions(true) end, { remap=false })

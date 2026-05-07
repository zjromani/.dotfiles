-- Prose writing mode for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()

    -- Soft-wrap config: wrap at word boundaries, indent wrapped lines under their parent
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.textwidth = 0
    vim.opt_local.colorcolumn = ""
    vim.opt_local.scrolloff = 999

    -- Traverse wrapped lines naturally in normal, visual, and insert modes
    local nv = { "n", "x" }
    vim.keymap.set(nv, "j", "gj", { buffer = buf, silent = true })
    vim.keymap.set(nv, "k", "gk", { buffer = buf, silent = true })
    vim.keymap.set(nv, "0", "g0", { buffer = buf, silent = true })
    vim.keymap.set(nv, "$", "g$", { buffer = buf, silent = true })
    vim.keymap.set(nv, "^", "g^", { buffer = buf, silent = true })
    vim.keymap.set(nv, "<Down>", "gj", { buffer = buf, silent = true })
    vim.keymap.set(nv, "<Up>", "gk", { buffer = buf, silent = true })
    vim.keymap.set("i", "<Down>", "<C-o>gj", { buffer = buf, silent = true })
    vim.keymap.set("i", "<Up>", "<C-o>gk", { buffer = buf, silent = true })

    vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { buffer = buf, desc = "Toggle markdown preview" })

    -- Defer so these win over any plugin FileType handlers (including markdown.nvim on_attach)
    vim.schedule(function()
      vim.opt_local.conceallevel = 0
      -- bullets.vim owns <CR> for list continuation; override anything markdown.nvim set
      vim.keymap.set("i", "<CR>", "<Plug>(bullets-newline)", { buffer = buf, silent = true })
    end)
  end,
})

-- Format on save via conform.nvim (prettier)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.md",
  callback = function(args)
    require("conform").format({ bufnr = args.buf, timeout_ms = 2000 })
  end,
})

-- ,z to toggle focus/zen mode (works in any file, most useful in markdown)
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Toggle zen mode" })

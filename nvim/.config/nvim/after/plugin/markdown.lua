-- Prose writing mode for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.textwidth = 0
    vim.opt_local.scrolloff = 999  -- typewriter effect: cursor stays vertically centered

    vim.keymap.set("n", "j", "gj", { buffer = true, silent = true })
    vim.keymap.set("n", "k", "gk", { buffer = true, silent = true })
    vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { buffer = true, desc = "Toggle markdown preview" })

    -- Defer so these win over any plugin FileType handlers (including markdown.nvim on_attach)
    vim.schedule(function()
      vim.opt_local.conceallevel = 0
      -- bullets.vim owns <CR> for list continuation; override anything markdown.nvim set
      vim.keymap.set("i", "<CR>", "<Plug>(bullets-newline)", { buffer = true, silent = true })
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

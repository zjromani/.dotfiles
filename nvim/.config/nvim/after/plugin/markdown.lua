-- Prose writing mode for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Wrap at word boundaries, indent continuation lines
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true

    -- Don't hard-wrap lines as you type
    vim.opt_local.textwidth = 0

    -- Move by visual lines (respects soft wrap) instead of logical lines
    vim.keymap.set("n", "j", "gj", { buffer = true, silent = true })
    vim.keymap.set("n", "k", "gk", { buffer = true, silent = true })

    -- Defer conceallevel so it runs after all other FileType handlers
    -- (Neovim's built-in ftplugin and plugins may set it to 2)
    vim.schedule(function()
      vim.opt_local.conceallevel = 0
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

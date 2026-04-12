-- Prose writing mode for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Wrap at word boundaries, indent continuation lines
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true

    -- Don't hard-wrap lines as you type
    vim.opt_local.textwidth = 0

    -- Show all raw markdown syntax (**, __, links, etc) — render elsewhere
    vim.opt_local.conceallevel = 0

    -- Move by visual lines (respects soft wrap) instead of logical lines
    vim.keymap.set("n", "j", "gj", { buffer = true, silent = true })
    vim.keymap.set("n", "k", "gk", { buffer = true, silent = true })
  end,
})

-- ,z to toggle focus/zen mode (works in any file, most useful in markdown)
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Toggle zen mode" })

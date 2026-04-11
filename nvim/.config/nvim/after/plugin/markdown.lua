-- Prose writing mode for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Wrap at word boundaries, indent continuation lines
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true

    -- Don't hard-wrap lines as you type
    vim.opt_local.textwidth = 0

    -- Hide syntax markers (** __ ` etc) so you see cleaner text while writing
    -- Set to 1 to keep markers visible when cursor is on the line; 2 to always hide
    vim.opt_local.conceallevel = 2

    -- Move by visual lines (respects soft wrap) instead of logical lines
    vim.keymap.set("n", "j", "gj", { buffer = true, silent = true })
    vim.keymap.set("n", "k", "gk", { buffer = true, silent = true })
  end,
})

-- ,z to toggle focus/zen mode (works in any file, most useful in markdown)
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Toggle zen mode" })

local builtin = require('telescope.builtin')

-- Configure telescope to filter out noise while allowing hidden files
require('telescope').setup({
  defaults = {
    file_ignore_patterns = {
      ".git/*",           -- Git internals
      "node_modules/*",   -- JS dependencies
      "__pycache__/*",    -- Python cache
      "%.pyc$",           -- Python bytecode
      ".DS_Store",        -- macOS metadata
    },
  },
})

vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader><leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader><leader>g', builtin.lsp_references, {})
vim.keymap.set('n', '<leader><leader>s', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

-- Search hidden files
vim.keymap.set('n', '<leader>p', function()
  builtin.find_files({ hidden = true })
end, {})

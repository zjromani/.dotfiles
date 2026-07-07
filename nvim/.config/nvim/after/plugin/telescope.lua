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
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
    },
  },
})

local function git_root()
  local root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then return nil end
  return root
end

-- Ctrl+P: search from git project root, fall back to CWD if not in a repo
vim.keymap.set('n', '<C-p>', function()
  local root = git_root()
  if root then
    builtin.find_files({ cwd = root, hidden = true })
  else
    builtin.find_files({ hidden = true })
  end
end, {})
vim.keymap.set('n', '<leader><leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader><leader>g', builtin.lsp_references, {})
vim.keymap.set('n', '<leader><leader>s', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

-- Search hidden files
vim.keymap.set('n', '<leader>p', function()
  builtin.find_files({ hidden = true })
end, {})

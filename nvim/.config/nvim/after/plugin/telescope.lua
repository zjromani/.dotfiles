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

-- Resolve the git root from the current buffer's directory, not Neovim's
-- global :pwd — in a large workspace without autochdir, :pwd stays wherever
-- Neovim was launched from and drifts away from whatever file you're editing.
local function git_root()
  local dir = vim.fn.expand('%:p:h')
  if dir == '' then dir = vim.fn.getcwd() end
  local root = vim.fn.systemlist({ 'git', '-C', dir, 'rev-parse', '--show-toplevel' })[1]
  if vim.v.shell_error ~= 0 then return nil end
  return root
end

-- Ctrl+P: search from git project root, fall back to the buffer's directory if not in a repo
vim.keymap.set('n', '<C-p>', function()
  local root = git_root()
  if root then
    builtin.find_files({ cwd = root, hidden = true })
  else
    local dir = vim.fn.expand('%:p:h')
    builtin.find_files({ cwd = dir ~= '' and dir or nil, hidden = true })
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

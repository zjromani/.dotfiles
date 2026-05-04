local ok, hop = pcall(require, 'hop')
if not ok then return end

local directions = require('hop.hint').HintDirection

-- <leader><leader>k = jump to line above cursor (easymotion equivalent)
vim.keymap.set('n', '<leader><leader>k', function()
  hop.hint_lines_skip_whitespace({ direction = directions.BEFORE_CURSOR })
end, { desc = 'Hop to line above' })

-- <leader><leader>j = jump to line below cursor
vim.keymap.set('n', '<leader><leader>j', function()
  hop.hint_lines_skip_whitespace({ direction = directions.AFTER_CURSOR })
end, { desc = 'Hop to line below' })

-- <leader><leader>w = hop to any word
vim.keymap.set('n', '<leader><leader>w', function()
  hop.hint_words()
end, { desc = 'Hop to word' })

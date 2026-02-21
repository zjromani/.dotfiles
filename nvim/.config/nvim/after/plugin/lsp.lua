-- LSP keymaps on attach
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)

    -- Copy diagnostics to clipboard
    vim.keymap.set('n', '<leader>cd', function()
      local line = vim.api.nvim_win_get_cursor(0)[1] - 1
      local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })
      local messages = {}
      for _, d in ipairs(diagnostics) do
        table.insert(messages, d.message)
      end
      vim.fn.setreg('+', table.concat(messages, "\n"))
    end, opts)
  end,
})

-- Mason setup
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'eslint',
    'kotlin_language_server',
    'buf_ls',
  },
})

-- LSP server setup for Neovim 0.11+
-- Enable servers after Neovim fully initializes to avoid URI errors
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local servers = { 'eslint', 'kotlin_language_server', 'buf_ls', 'lua_ls', 'ts_ls' }
    for _, server in ipairs(servers) do
      -- Safely enable each server using default configs
      pcall(vim.lsp.enable, server)
    end
  end,
})

-- Completion setup
require('blink.cmp').setup({
  keymap = {
    preset = 'none',
    ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-y>'] = { 'select_and_accept' },
    ['<C-n>'] = { 'select_next', 'fallback' },
    ['<C-p>'] = { 'select_prev', 'fallback' },
    ['<C-e>'] = { 'hide', 'fallback' },
  },
  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = 'mono',
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
    trigger = {
      -- Only show after typing at least 1 char, reduces noise
      show_on_keyword = true,
      show_on_trigger_character = true,
    },
  },
  snippets = { preset = 'luasnip' },
})

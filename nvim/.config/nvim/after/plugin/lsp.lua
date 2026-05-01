-- LSP keymaps on attach — only map what the server actually supports
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    local opts = { buffer = bufnr, remap = false }

    if client.supports_method('textDocument/definition') then
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    end
    if client.supports_method('textDocument/hover') then
      vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
    end
    if client.supports_method('textDocument/codeAction') then
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    end
    if client.supports_method('textDocument/rename') then
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    end

    -- diagnostics are local to nvim, not server-specific
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

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

-- Install non-LSP tools (formatters, linters) via mason directly
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    local registry = require('mason-registry')
    local tools = { 'markdownlint-cli2' }
    for _, tool in ipairs(tools) do
      local ok, pkg = pcall(registry.get_package, tool)
      if ok and not pkg:is_installed() then
        pkg:install()
      end
    end
  end,
})

require('mason-lspconfig').setup({
  ensure_installed = {
    'eslint',
    'kotlin_language_server',
    'buf_ls',
    'ts_ls',
  },
  -- ast_grep requires a sgconfig.yml project file; harper_ls exits 101 without config
  automatic_enable = {
    exclude = { 'ast_grep', 'harper_ls' },
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
  enabled = function()
    return not vim.tbl_contains({ 'markdown' }, vim.bo.filetype)
  end,
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

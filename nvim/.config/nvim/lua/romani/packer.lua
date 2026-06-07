-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'


  use {
    'nvim-telescope/telescope.nvim', branch = 'master',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
    "nvim-telescope/telescope-frecency.nvim", tag = "1.2.2",
    config = function()
      require"telescope".load_extension("frecency")
    end,
    requires = {"kkharji/sqlite.lua"}
  }

  use {
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          blink_cmp = true,
          treesitter = true,
          harpoon = true,
          telescope = { enabled = true },
          mason = true,
          native_lsp = {
            enabled = true,
          },
        },
      })
    end
  }

  use {
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons" },
  }

  use("nvim-treesitter/nvim-treesitter", {run = ":TSUpdate"})
  use("theprimeagen/harpoon")
  use("mbbill/undotree")
  use("tpope/vim-fugitive")
  use("tpope/vim-rhubarb")
  -- LSP Support
  use {'neovim/nvim-lspconfig'}
  use {'williamboman/mason.nvim'}
  use {'williamboman/mason-lspconfig.nvim'}

  -- Autocompletion (pre-built binary via tagged release)
  use { 'saghen/blink.cmp', tag = 'v0.*', run = ':lua require("blink.cmp").download_release_artifact()' }

  -- Snippets
  use {'L3MON4D3/LuaSnip'}
  use {'rafamadriz/friendly-snippets'}
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })

  -- Auto-continue bullets/numbered lists on Enter; Ctrl-D deletes current bullet
  use {
    "dkarter/bullets.vim",
    ft = "markdown",
    setup = function()
      vim.g.bullets_enabled_file_types = { "markdown" }
      vim.g.bullets_outline_levels = { "num", "abc", "std-" }
    end,
  }

  -- Markdown editing ergonomics: heading nav, inline style toggles, checkboxes
  use({
    "tadmccorkle/markdown.nvim",
    ft = "markdown",
    config = function()
      require("markdown").setup({
        -- disable built-in list continuation — bullets.vim owns <CR>
        mappings = {
          go_curr_heading = false,
          go_parent_heading = false,
          go_next_heading = "]]",
          go_prev_heading = "[[",
          inline_surround_toggle = false,
          inline_surround_toggle_line = false,
          inline_surround_delete = false,
          inline_surround_change = false,
          link_add = false,
          link_follow = false,
          go_next_link = false,
          go_prev_link = false,
        },
        on_attach = function(bufnr)
          local opts = { buffer = bufnr, silent = true }
          vim.keymap.set("n", "<leader>tt", "<Plug>(markdown_toggle_task)", opts)
          vim.keymap.set("n", "]]", "<Plug>(markdown_next_heading)", opts)
          vim.keymap.set("n", "[[", "<Plug>(markdown_prev_heading)", opts)
          vim.keymap.set({ "n", "v" }, "<leader>mb", "<Plug>(markdown_toggle_strong)", opts)
          vim.keymap.set({ "n", "v" }, "<leader>mi", "<Plug>(markdown_toggle_emphasis)", opts)
          vim.keymap.set({ "n", "v" }, "<leader>ms", "<Plug>(markdown_toggle_strikethrough)", opts)
          vim.keymap.set({ "n", "v" }, "<leader>mc", "<Plug>(markdown_toggle_code)", opts)
        end,
      })
    end,
  })

  -- Format on save (markdown via prettier, triggered from after/plugin/markdown.lua)
  use {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          markdown = { "prettier" },
        },
      })

      -- Replace the LSP-only <leader>f with conform (falls back to LSP for other filetypes)
      vim.keymap.set({ "n", "v" }, "<leader>f", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format buffer" })
    end
  }

  -- Zen/focus writing mode: centers buffer, hides UI chrome, soft-wrap on
  -- Twilight is intentionally disabled — it caused flicker and only highlighted
  -- a portion of the file at a time, making zen mode feel broken.
  use {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({
        window = {
          width = 80,        -- absolute column width — narrower = more side padding
          height = 1,        -- full height of the editor
          options = {
            signcolumn = "no",
            number = false,
            relativenumber = false,
            cursorline = false,
            cursorcolumn = false,
            foldcolumn = "0",
            list = false,
            colorcolumn = "",
          },
        },
        plugins = {
          options = {
            enabled = true,
            laststatus = 0,
          },
          twilight = { enabled = false },
          gitsigns = { enabled = false },
        },
        on_open = function(_win)
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
          vim.opt_local.breakindent = true
          vim.opt_local.winbar = "%=%f  %=%m"
          vim.opt_local.scrolloff = 999
          -- NeoVim's topline is clamped so it can never scroll past the last buffer line, which means
          -- scrolloff=999 can't center the cursor when writing on the last line. winrestview tricks
          -- don't bypass this clamp. The only reliable fix is real blank lines below the last content
          -- line so NeoVim has actual content to scroll through.
          local buf = vim.api.nvim_get_current_buf()
          local was_modified = vim.bo[buf].modified
          local pad = math.floor(vim.fn.winheight(0) / 2)
          local blank = {}
          for _ = 1, pad do blank[#blank + 1] = '' end
          vim.api.nvim_buf_set_lines(buf, -1, -1, false, blank)
          vim.bo[buf].modified = was_modified
          vim.b[buf].zen_pad = pad

          local group = vim.api.nvim_create_augroup('ZenTypewriterEOF', { clear = true })
          -- Strip padding before save so blank lines are never written to disk
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = group, buffer = buf,
            callback = function()
              local p = vim.b.zen_pad
              if not p then return end
              local lc = vim.api.nvim_buf_line_count(0)
              vim.api.nvim_buf_set_lines(0, lc - p, lc, false, {})
            end,
          })
          -- Re-add padding after save so typewriter mode stays active
          vim.api.nvim_create_autocmd('BufWritePost', {
            group = group, buffer = buf,
            callback = function()
              local p = vim.b.zen_pad
              if not p then return end
              local lines = {}
              for _ = 1, p do lines[#lines + 1] = '' end
              vim.api.nvim_buf_set_lines(0, -1, -1, false, lines)
              vim.bo.modified = false
            end,
          })
        end,
        on_close = function()
          local p = vim.b.zen_pad
          if p then
            local was_modified = vim.bo.modified
            local lc = vim.api.nvim_buf_line_count(0)
            vim.api.nvim_buf_set_lines(0, lc - p, lc, false, {})
            vim.bo.modified = was_modified
            vim.b.zen_pad = nil
          end
          pcall(vim.api.nvim_del_augroup_by_name, 'ZenTypewriterEOF')
          vim.opt_local.winbar = ""
          vim.opt_local.scrolloff = 8
          if vim.bo.filetype ~= "markdown" then
            vim.opt_local.wrap = false
          end
        end,
      })
    end
  }

  -- Virtual blank lines at EOF so scrolloff=999 (typewriter mode) works on the last line
  use {
    'Aasim-A/scrollEOF.nvim',
    config = function()
      require('scrollEOF').setup({
        insert_mode = true,
        disabled_filetypes = { 'terminal', 'nofile', 'quickfix' },
      })
    end,
  }

  -- Easymotion-style jump labels: <leader><leader>k/j for line jumps, <leader><leader>w for words
  use {
    'smoka7/hop.nvim',
    tag = '*',
    config = function()
      require('hop').setup({ keys = 'etovxqpdygfblzhckisuran' })
    end,
  }

end)

-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'


  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
    "nvim-telescope/telescope-frecency.nvim",
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
  use("nvim-treesitter/playground")
  use("theprimeagen/harpoon")
  use("mbbill/undotree")
  use("tpope/vim-fugitive")
  use("tpope/vim-rhubarb")
  -- LSP Support
  use {'neovim/nvim-lspconfig'}
  use {'williamboman/mason.nvim'}
  use {'williamboman/mason-lspconfig.nvim'}

  -- Autocompletion
  use { 'saghen/blink.cmp', tag = 'v0.*' }

  -- Snippets
  use {'L3MON4D3/LuaSnip'}
  use {'rafamadriz/friendly-snippets'}
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })

  -- Markdown editing ergonomics: list continuation, heading nav, inline style toggling
  use({
    "tadmccorkle/markdown.nvim",
    ft = "markdown",
    config = function()
      require("markdown").setup({
        -- list continuation (Enter continues bullets/numbers, Shift-Enter breaks out)
        on_attach = function(bufnr)
          local opts = { buffer = bufnr, silent = true }
          -- toggle checkbox: [ ] <-> [x]
          vim.keymap.set("n", "<leader>tt", "<Plug>(markdown_toggle_task)", opts)
          -- Tab/S-Tab indent/unindent list items in insert mode
          vim.keymap.set("i", "<Tab>",   "<Plug>(markdown_indent_list_item)", opts)
          vim.keymap.set("i", "<S-Tab>", "<Plug>(markdown_unindent_list_item)", opts)
          -- heading navigation
          vim.keymap.set("n", "]]", "<Plug>(markdown_next_heading)", opts)
          vim.keymap.set("n", "[[", "<Plug>(markdown_prev_heading)", opts)
          -- inline style toggles (normal + visual)
          vim.keymap.set({ "n", "v" }, "<leader>mb", "<Plug>(markdown_toggle_strong)", opts)
          vim.keymap.set({ "n", "v" }, "<leader>mi", "<Plug>(markdown_toggle_emphasis)", opts)
          vim.keymap.set({ "n", "v" }, "<leader>ms", "<Plug>(markdown_toggle_strikethrough)", opts)
          vim.keymap.set({ "n", "v" }, "<leader>mc", "<Plug>(markdown_toggle_code)", opts)
        end,
      })
    end,
  })

  -- Format on save (markdown via markdownlint-cli2, triggered from after/plugin/markdown.lua)
  use {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          markdown = { "markdownlint-cli2" },
        },
      })

      -- Replace the LSP-only <leader>f with conform (falls back to LSP for other filetypes)
      vim.keymap.set({ "n", "v" }, "<leader>f", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format buffer" })
    end
  }

  -- Zen/focus writing mode: centers buffer, hides UI chrome
  use {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({
        window = {
          width = 0.6, -- 60% of screen keeps side blocks present but not huge
          options = {
            signcolumn = "no",
            colorcolumn = "",
            foldcolumn = "2", -- left padding inside the writing area
          },
        },
        plugins = {
          options = {
            laststatus = 2, -- keep statusline visible in zen mode
          },
        },
      })
    end
  }

end)

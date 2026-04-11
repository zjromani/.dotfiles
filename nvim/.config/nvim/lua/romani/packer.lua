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
      require("markdown").setup({})
    end,
  })

  -- Format on save (markdown via markdownlint-cli2)
  use {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          markdown = { "markdownlint-cli2" },
        },
        format_on_save = {
          timeout_ms = 2000,
          lsp_fallback = false,
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
          width = 80,
          options = {
            number = false,
            relativenumber = false,
            signcolumn = "no",
            colorcolumn = "",
          },
        },
      })
    end
  }

end)

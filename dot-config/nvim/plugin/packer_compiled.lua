-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/zacharyromani/.cache/nvim/packer_hererocks/2.1.1703358377/share/lua/5.1/?.lua;/Users/zacharyromani/.cache/nvim/packer_hererocks/2.1.1703358377/share/lua/5.1/?/init.lua;/Users/zacharyromani/.cache/nvim/packer_hererocks/2.1.1703358377/lib/luarocks/rocks-5.1/?.lua;/Users/zacharyromani/.cache/nvim/packer_hererocks/2.1.1703358377/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/zacharyromani/.cache/nvim/packer_hererocks/2.1.1703358377/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["CopilotChat.nvim"] = {
    config = { "\27LJ\2\n\127\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0]Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.\vnotify\bvim�\3\1\0\6\0\v\0\0176\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\3\0005\4\4\0=\4\5\0033\4\6\0=\4\a\0034\4\3\0005\5\b\0>\5\1\0045\5\t\0>\5\2\4=\4\n\3B\1\2\1K\0\1\0\17dependencies\1\2\0\0\26nvim-lua/plenary.nvim\1\2\0\0\"nvim-telescope/telescope.nvim\nbuild\0\fprompts\1\0\4\vReview?Review the following code and provide concise suggestions.\nTestsKBriefly explain how the selected code works, then generate unit tests.\fExplain.Explain how it works by English language.\rRefactor:Refactor the code to improve clarity and readability.\1\0\4\14show_help\byes\ndebug\2\nevent\rVeryLazy\nproxy\v******\nsetup\16CopilotChat\frequire\0" },
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/CopilotChat.nvim",
    url = "https://github.com/CopilotC-Nvim/CopilotChat.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["copilot.lua"] = {
    commands = { "Copilot" },
    config = { "\27LJ\2\n�\4\0\0\5\0\16\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\b\0005\3\3\0005\4\4\0=\4\5\0035\4\6\0=\4\a\3=\3\t\0025\3\n\0005\4\v\0=\4\5\3=\3\f\0025\3\r\0=\3\14\0024\3\0\0=\3\15\2B\0\2\1K\0\1\0\26server_opts_overrides\14filetypes\1\0\t\rhgcommit\1\14gitrebase\1\14gitcommit\1\thelp\1\rmarkdown\2\tyaml\2\6.\1\bcvs\1\bsvn\1\15suggestion\1\0\6\fdismiss\n<C-]>\vaccept\n<M-l>\tprev\n<M-[>\16accept_line\1\16accept_word\1\tnext\n<M-]>\1\0\3\fenabled\2\rdebounce\3K\17auto_trigger\2\npanel\1\0\1\25copilot_node_command\tnode\vlayout\1\0\2\nratio\4����\t����\3\rposition\vbottom\vkeymap\1\0\5\14jump_prev\a[[\vaccept\t<CR>\topen\v<M-CR>\frefresh\agr\14jump_next\a]]\1\0\2\fenabled\2\17auto_refresh\1\nsetup\fcopilot\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/opt/copilot.lua",
    url = "https://github.com/zbirenbaum/copilot.lua"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  harpoon = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/harpoon",
    url = "https://github.com/theprimeagen/harpoon"
  },
  ["lsp-zero.nvim"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/lsp-zero.nvim",
    url = "https://github.com/VonHeikemen/lsp-zero.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["monokai-pro"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\16monokai-pro\frequire\0" },
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/monokai-pro",
    url = "https://github.com/loctvl842/monokai-pro.nvim"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["sqlite.lua"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/sqlite.lua",
    url = "https://github.com/kkharji/sqlite.lua"
  },
  ["telescope-frecency.nvim"] = {
    config = { "\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/telescope-frecency.nvim",
    url = "https://github.com/nvim-telescope/telescope-frecency.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  undotree = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-rhubarb"] = {
    loaded = true,
    path = "/Users/zacharyromani/.local/share/nvim/site/pack/packer/start/vim-rhubarb",
    url = "https://github.com/tpope/vim-rhubarb"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: monokai-pro
time([[Config for monokai-pro]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\16monokai-pro\frequire\0", "config", "monokai-pro")
time([[Config for monokai-pro]], false)
-- Config for: telescope-frecency.nvim
time([[Config for telescope-frecency.nvim]], true)
try_loadstring("\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0", "config", "telescope-frecency.nvim")
time([[Config for telescope-frecency.nvim]], false)
-- Config for: CopilotChat.nvim
time([[Config for CopilotChat.nvim]], true)
try_loadstring("\27LJ\2\n\127\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0]Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.\vnotify\bvim�\3\1\0\6\0\v\0\0176\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\3\0005\4\4\0=\4\5\0033\4\6\0=\4\a\0034\4\3\0005\5\b\0>\5\1\0045\5\t\0>\5\2\4=\4\n\3B\1\2\1K\0\1\0\17dependencies\1\2\0\0\26nvim-lua/plenary.nvim\1\2\0\0\"nvim-telescope/telescope.nvim\nbuild\0\fprompts\1\0\4\vReview?Review the following code and provide concise suggestions.\nTestsKBriefly explain how the selected code works, then generate unit tests.\fExplain.Explain how it works by English language.\rRefactor:Refactor the code to improve clarity and readability.\1\0\4\14show_help\byes\ndebug\2\nevent\rVeryLazy\nproxy\v******\nsetup\16CopilotChat\frequire\0", "config", "CopilotChat.nvim")
time([[Config for CopilotChat.nvim]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.api.nvim_create_user_command, 'Copilot', function(cmdargs)
          require('packer.load')({'copilot.lua'}, { cmd = 'Copilot', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'copilot.lua'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('Copilot ', 'cmdline')
      end})
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'copilot.lua'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end

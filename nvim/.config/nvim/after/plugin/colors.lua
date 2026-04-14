function ColorMyPencils(color) 
	color = color or "catppuccin"
	vim.cmd.colorscheme(color)

	--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

end

ColorMyPencils()

-- Match zen-mode backdrop to Catppuccin Mocha bg so sidebars don't look black
vim.api.nvim_set_hl(0, "ZenBg", { bg = "#1e1e2e" })

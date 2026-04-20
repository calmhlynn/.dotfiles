require("catppuccin").setup({
	flavour = "mocha",
	term_colors = true,
	custom_highlights = function(colors)
		return {
			LspInlayHint = { fg = colors.overlay0, bg = "NONE" },
			DiagnosticUnderlineError = { undercurl = true, sp = colors.red },
			DiagnosticUnderlineWarn = { undercurl = true, sp = colors.yellow },
			DiagnosticUnderlineInfo = { undercurl = true, sp = colors.sky },
			DiagnosticUnderlineHint = { undercurl = true, sp = colors.teal },
		}
	end,
	integrations = {
		bufferline = true,
		gitsigns = true,
		mason = true,
		render_markdown = true,
		snacks = true,
		which_key = true,
	},
})

vim.cmd.colorscheme("catppuccin-mocha")

return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		require("kanagawa").setup({
			overrides = function(colors)
				-- local theme = colors.theme
				return {
					Normal = { fg = colors.palette.dragonWhite, bg = colors.palette.dragonBlack3 },
					NormalFloat = { fg = colors.palette.fujiWhite, bg = colors.palette.dragonBlack3 },
					FloatBorder = { fg = colors.palette.fujiWhite, bg = colors.palette.dragonBlack3 },

					-- AvanteSidebarWinSeparator = { fg = colors.palette.fujiWhite, bg = colors.palette.dragonBlack3 },
				}
			end,
		})
		vim.cmd([[colorscheme kanagawa-dragon]])
	end,
	build = "KanagawaComile",
}

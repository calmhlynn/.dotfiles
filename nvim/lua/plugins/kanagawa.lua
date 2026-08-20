require("kanagawa").setup({
	theme = "dragon",
	commentStyle = { italic = false },
	overrides = function(colors)
		local palette = colors.palette
		return {
			["@markup.raw.block"] = { link = "Normal" },
			["@comment.documentation"] = { fg = "#a9cbc6" },

			RenderMarkdownH1Bg = { bg = palette.dragonBlack4 },
			RenderMarkdownH2Bg = { bg = palette.dragonBlack4 },
			RenderMarkdownH3Bg = { bg = palette.dragonBlack4 },
			RenderMarkdownH4Bg = { bg = palette.dragonBlack4 },
			RenderMarkdownH5Bg = { bg = palette.dragonBlack4 },
			RenderMarkdownH6Bg = { bg = palette.dragonBlack4 },
		}
	end,
})

vim.cmd.colorscheme("kanagawa-dragon")

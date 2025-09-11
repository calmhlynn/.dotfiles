return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		require("kanagawa").setup({
			overrides = function(colors)
				local palette = colors.palette
				local overrides = {
					-- Existing overrides
					Normal = { bg = palette.dragonBlack3 },
					NormalFloat = { fg = palette.fujiWhite, bg = palette.dragonBlack3 },
					FloatBorder = { fg = palette.fujiWhite, bg = palette.dragonBlack3 },
					CursorLine = { bg = palette.dragonBlack4 },
					CursorLineNr = { fg = palette.fujiWhite },
				}

				-- RenderMarkdown.nvim overrides (only if plugin is installed)
				if pcall(require, "render-markdown") then
					overrides = vim.tbl_deep_extend("force", overrides, {
						-- Headers: Vibrant colors for visual hierarchy
						RenderMarkdownH1 = { fg = palette.waveRed, bold = true },
						RenderMarkdownH2 = { fg = palette.autumnOrange, bold = true },
						RenderMarkdownH3 = { fg = palette.carpYellow, bold = true },
						RenderMarkdownH4 = { fg = palette.springGreen, bold = true },
						RenderMarkdownH5 = { fg = palette.crystalBlue, bold = true },
						RenderMarkdownH6 = { fg = palette.oniViolet, bold = true },

						-- Header text colors to match the header symbols
						["@markup.heading.1.markdown"] = { fg = palette.waveRed, bold = true },
						["@markup.heading.2.markdown"] = { fg = palette.autumnOrange, bold = true },
						["@markup.heading.3.markdown"] = { fg = palette.carpYellow, bold = true },
						["@markup.heading.4.markdown"] = { fg = palette.springGreen, bold = true },
						["@markup.heading.5.markdown"] = { fg = palette.crystalBlue, bold = true },
						["@markup.heading.6.markdown"] = { fg = palette.oniViolet, bold = true },

						-- Header backgrounds: Subtle, muted backgrounds to differentiate headers
						RenderMarkdownH1Bg = { bg = palette.dragonBlack4 },
						RenderMarkdownH2Bg = { bg = palette.dragonBlack4 },
						RenderMarkdownH3Bg = { bg = palette.dragonBlack4 },
						RenderMarkdownH4Bg = { bg = palette.dragonBlack4 },
						RenderMarkdownH5Bg = { bg = palette.dragonBlack4 },
						RenderMarkdownH6Bg = { bg = palette.dragonBlack4 },

						-- Code blocks: More vibrant highlighting
						RenderMarkdownCode = { bg = palette.dragonBlack4 },
						RenderMarkdownCodeInfo = { fg = palette.waveAqua2 },
						RenderMarkdownCodeBorder = { bg = palette.dragonBlack4 },
						RenderMarkdownCodeFallback = { fg = palette.oldWhite },
						RenderMarkdownCodeInline = { fg = palette.fujiWhite, bg = palette.dragonBlack4 },

						-- Quotes: Colorful yet elegant for nested quotes
						RenderMarkdownQuote = { fg = palette.katanaGray, italic = true },
						RenderMarkdownQuote1 = { fg = palette.oniViolet, italic = true },
						RenderMarkdownQuote2 = { fg = palette.crystalBlue, italic = true },
						RenderMarkdownQuote3 = { fg = palette.waveAqua2, italic = true },
						RenderMarkdownQuote4 = { fg = palette.springViolet1, italic = true },
						RenderMarkdownQuote5 = { fg = palette.lightBlue, italic = true },
						RenderMarkdownQuote6 = { fg = palette.waveAqua1, italic = true },

						-- Inline elements: Vibrant and diverse colors
						RenderMarkdownInlineHighlight = { bg = palette.dragonBlack5, fg = palette.autumnYellow },
						RenderMarkdownBullet = { fg = palette.dragonAsh },
						RenderMarkdownDash = { fg = palette.dragonGray },
						RenderMarkdownSign = { fg = palette.katanaGray, bg = palette.dragonBlack3 },
						RenderMarkdownMath = { fg = palette.springViolet1, italic = true },
						RenderMarkdownIndent = { fg = palette.oniViolet },
						RenderMarkdownHtmlComment = { fg = palette.fujiGray, italic = true },
						RenderMarkdownLink = { fg = palette.crystalBlue, underline = true },
						RenderMarkdownWikiLink = { fg = palette.lightBlue, underline = true },

						-- Checkboxes: Clear visual distinction
						RenderMarkdownUnchecked = { fg = palette.katanaGray },
						RenderMarkdownChecked = { fg = palette.springGreen },
						RenderMarkdownTodo = { fg = palette.waveRed },

						-- Tables: Vibrant headers with good contrast
						RenderMarkdownTableHead = { fg = palette.waveAqua2, bold = true },
						RenderMarkdownTableRow = { fg = palette.oldWhite },
						RenderMarkdownTableFill = { fg = palette.autumnYellow },

						-- Callouts: Bright and attention-grabbing
						RenderMarkdownSuccess = { fg = palette.springGreen },
						RenderMarkdownInfo = { fg = palette.crystalBlue },
						RenderMarkdownHint = { fg = palette.waveAqua1 },
						RenderMarkdownWarn = { fg = palette.autumnYellow },
						RenderMarkdownError = { fg = palette.waveRed },
					})
				end

				-- Noice.nvim overrides (only if plugin is installed)
				if pcall(require, "noice") then
					overrides = vim.tbl_deep_extend("force", overrides, {
						-- Cmdline popup
						NoiceCmdlinePopup = {
							fg = palette.fujiWhite,
						},
						NoiceCmdlinePopupBorder = {
							fg = palette.dragonGray,
						},

						-- Cmdline
						NoiceCmdline = {
							fg = palette.fujiWhite,
						},
						NoiceCmdlineIcon = {
							fg = palette.crystalBlue,
						},
						NoiceCmdlineIconCmdline = {
							fg = palette.dragonGreen,
						},
						NoiceCmdlineIconFilter = {
							fg = palette.autumnYellow,
						},
						NoiceCmdlineIconLua = {
							fg = palette.dragonBlue,
						},
						NoiceCmdlineIconSearch = {
							fg = palette.waveRed,
						},
					})
				end

				return overrides
			end,
		})

		vim.cmd([[colorscheme kanagawa-dragon]])
	end,
}

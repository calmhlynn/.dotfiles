require("catppuccin").setup({
	flavour = "mocha",
	term_colors = true,
	styles = { comments = {} },
	custom_highlights = function(colors)
		local function darken(color)
			return require("catppuccin.utils.colors").darken(color, 0.095, colors.base)
		end

		return {
			LspInlayHint = { fg = colors.overlay0, bg = "NONE" },
			DiagnosticUnderlineError = { undercurl = true, sp = colors.red },
			DiagnosticUnderlineWarn = { undercurl = true, sp = colors.yellow },
			DiagnosticUnderlineInfo = { undercurl = true, sp = colors.sky },
			DiagnosticUnderlineHint = { undercurl = true, sp = colors.teal },
			["@markup.raw.block"] = { link = "Normal" },
			["@comment.documentation"] = { fg = "#a9cbc6" },

			-- Markdown: keep structure on one cool ramp and leave text
			-- emphasis uncolored, so a paragraph never mixes hues.
			["@markup.strong"] = { fg = colors.text, bold = true },
			["@markup.italic"] = { fg = colors.text, italic = true },
			["@markup.raw"] = { fg = colors.text },
			["@markup.quote"] = { fg = colors.subtext0 },
			RenderMarkdownCodeInline = { fg = colors.text, bg = colors.surface0 },
			RenderMarkdownQuote = { fg = colors.subtext0 },
			RenderMarkdownBullet = { fg = colors.lavender },
			RenderMarkdownTableHead = { fg = colors.blue },
			RenderMarkdownTableRow = { fg = colors.text },
			["@markup.heading.1.markdown"] = { fg = colors.mauve, bold = true },
			["@markup.heading.2.markdown"] = { fg = colors.lavender, bold = true },
			["@markup.heading.3.markdown"] = { fg = colors.blue, bold = true },
			["@markup.heading.4.markdown"] = { fg = colors.sapphire, bold = true },
			["@markup.heading.5.markdown"] = { fg = colors.sky, bold = true },
			["@markup.heading.6.markdown"] = { fg = colors.teal, bold = true },
			RenderMarkdownH1 = { fg = colors.mauve },
			RenderMarkdownH2 = { fg = colors.lavender },
			RenderMarkdownH3 = { fg = colors.blue },
			RenderMarkdownH4 = { fg = colors.sapphire },
			RenderMarkdownH5 = { fg = colors.sky },
			RenderMarkdownH6 = { fg = colors.teal },
			RenderMarkdownH1Bg = { bg = darken(colors.mauve) },
			RenderMarkdownH2Bg = { bg = darken(colors.lavender) },
			RenderMarkdownH3Bg = { bg = darken(colors.blue) },
			RenderMarkdownH4Bg = { bg = darken(colors.sapphire) },
			RenderMarkdownH5Bg = { bg = darken(colors.sky) },
			RenderMarkdownH6Bg = { bg = darken(colors.teal) },
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

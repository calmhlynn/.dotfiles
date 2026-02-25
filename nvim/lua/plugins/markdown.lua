return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			file_types = { "markdown", "Avante" },
			render_modes = { "n", "v", "i", "c" },
		},
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		config = function()
			require("render-markdown").setup({
				heading = {
					enabled = true,
					render_modes = false,
					atx = true,
					setext = true,
					sign = true,
					icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
					position = "overlay",
					signs = { "󰫎 " },
					width = "full",
					left_margin = 0,
					left_pad = 0,
					right_pad = 0,
					min_width = 0,
					border = false,
					border_virtual = false,
					border_prefix = false,
					above = "▄",
					below = "▀",
					backgrounds = {
						"RenderMarkdownH1Bg",
						"RenderMarkdownH2Bg",
						"RenderMarkdownH3Bg",
						"RenderMarkdownH4Bg",
						"RenderMarkdownH5Bg",
						"RenderMarkdownH6Bg",
					},
					foregrounds = {
						"RenderMarkdownH1",
						"RenderMarkdownH2",
						"RenderMarkdownH3",
						"RenderMarkdownH4",
						"RenderMarkdownH5",
						"RenderMarkdownH6",
					},
					custom = {},
				},

				latex = { enabled = false },
				completions = { lsp = { enabled = true } },
			})
			vim.keymap.set("n", "<leader>m", ":RenderMarkdown toggle<CR>", { silent = true })
		end,
	},
}

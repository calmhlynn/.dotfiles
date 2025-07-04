return {

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			file_types = { "markdown", "Avante" },
			render_modes = { "n", "v", "i", "c" },
		},
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.keymap.set("n", "<leader>m", ":RenderMarkdown toggle<CR>", { silent = true })
		end,
	},
}

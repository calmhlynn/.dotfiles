return {
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		lazy = false,
	},
	{
		"saecki/crates.nvim",
		tag = "stable",

		config = function()
			require("crates").setup({
				lsp = {
					enabled = true,
					on_attach = LSP_ON_ATTACH,
					actions = true,
					completion = true,
					hover = true,
				},

				completion = {
					crates = {
						enabled = true,
						max_results = 8,
						min_chars = 3,
					},
				},
			})
			vim.keymap.set(
				"n",
				"<Leader>cf",
				":Crates show_features_popup<CR>",
				{ desc = "Crates show features popup" }
			)
			vim.keymap.set("n", "<Leader>cp", ":Crates focus_popup<CR>", { desc = "Crates focus popup" })
		end,
	},
}

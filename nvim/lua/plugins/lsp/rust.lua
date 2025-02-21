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

vim.keymap.set("n", "<Leader>cf", ":Crates show_features_popup<CR>", { silent = true })
vim.keymap.set("n", "<Leader>cp", ":Crates focus_popup<CR>", { silent = true })

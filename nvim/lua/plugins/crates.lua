require("crates").setup({
	lsp = {
		enabled = true,
		on_attach = nil,
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

vim.keymap.set("n", "<leader>cf", "<cmd>Crates show_features_popup<cr>", { desc = "Crates show features popup" })
vim.keymap.set("n", "<leader>cp", "<cmd>Crates focus_popup<cr>", { desc = "Crates focus popup" })

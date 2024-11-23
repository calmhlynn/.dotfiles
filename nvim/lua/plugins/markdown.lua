require("render-markdown").setup({
	-- enabled = false,
	file_types = { "markdown", "Avante" },
	render_modes = { "n", "v", "i", "c" },

	vim.keymap.set("n", "<leader>m", ":RenderMarkdown toggle<CR>", { silent = true }),
})

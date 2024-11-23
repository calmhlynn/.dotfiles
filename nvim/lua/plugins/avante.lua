require("avante").setup({

	provider = "openai",
	openai = {
		api_key_name = "cmd:security find-generic-password -s OPENAI_KEY -a calmhlynn -w",
	},
	vim.keymap.set("n", "<leader>ai", ":AvanteToggle<CR>", { silent = true }),
})
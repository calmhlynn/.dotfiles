require("chatgpt").setup({

	api_key_cmd = "op read op://Personal/OPENAI_API_KEY/password --no-newline",
	openai_params = {
		model = "gpt-4o",
	},
	openai_edit_params = {
		model = "gpt-4o",
	},
})

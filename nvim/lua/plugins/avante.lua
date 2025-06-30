require("avante").setup({
	provider = "gemini",
	mode = "agentic",
	providers = {
		claude = {
			model = "claude-sonnet-4-20250514",
			api_key_name = "cmd:pass show api_tokens/claude",
		},
		openai = {
			model = "o4-mini-2025-04-16",
			api_key_name = "cmd:pass show api_tokens/openai",
		},
		gemini = {
			model = "gemini-2.5-flash",
			api_key_name = "cmd:pass show api_tokens/gemini",
		},
	},

	keys = {
		{
			"<leader>a+",
			function()
				local tree_ext = require("avante.extensions.nvim_tree")
				tree_ext.add_file()
			end,
			desc = "Select file in NvimTree",
			ft = "NvimTree",
		},
		{
			"<leader>a-",
			function()
				local tree_ext = require("avante.extensions.nvim_tree")
				tree_ext.remove_file()
			end,
			desc = "Deselect file in NvimTree",
			ft = "NvimTree",
		},
	},
	opts = {
		--- other configurations
		selector = {
			exclude_auto_select = { "NvimTree" },
		},
	},
})

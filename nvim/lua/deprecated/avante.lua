return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false, -- set this if you want to always pull the latest change
	build = "make",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		-- "rebelot/kanagawa.nvim",

		-- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"folke/snacks.nvim",
		--- The below dependencies are optional,
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
	config = function()
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
			input = {
				provider = "snacks", -- "native" | "dressing" | "snacks"
				provider_opts = {
					-- Snacks input configuration
					title = "Avante Input",
					icon = " ",
					placeholder = "Enter your API key...",
				},
			},
			windows = {
				input = {
					height = 16,
				},
			},
		})
	end,
}

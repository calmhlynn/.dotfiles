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
				render_modes = { "n", "c", "i", "v" },
				anti_conceal = {
					enabled = false,
				},
			},
			ft = { "markdown", "Avante" },
		},
	},
	config = function()
		require("avante").setup({
			provider = "claude-code",
			mode = "agentic",
			acp_providers = {
				["claude-code"] = {
					command = "npx",
					args = { "@zed-industries/claude-code-acp" },
					env = {
						NODE_NO_WARNINGS = "1",
						ANTHROPIC_API_KEY = vim.fn.json_decode(
							vim.fn.readfile(vim.fn.expand("~/.claude/.credentials.json"))[1]
						)["anthropic_api_key"],
					},
				},
			},
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
			behaviour = {
				minimize_diff = false,
				auto_add_current_file = true,
				auto_approve_tool_permissions = false,
				confirmation_ui_style = "inline_buttons",
				acp_follow_agent_locations = true,
			},
			mappings = {
				diff = {
					ours = "co",
					theirs = "ct",
					all_theirs = "ca",
					both = "cb",
					cursor = "cc",
					next = "]x",
					prev = "[x",
				},
				suggestion = {
					accept = "<M-l>",
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
				jump = {
					next = "]]",
					prev = "[[",
				},
				submit = {
					normal = "<CR>",
					insert = "<C-s>",
				},
				sidebar = {
					apply_all = "A",
					apply_cursor = "a",
					switch_windows = "<Tab>",
					reverse_switch_windows = "<S-Tab>",
				},
			},
			windows = {
				position = "right",
				wrap = true,
				width = 30,
				sidebar_header = {
					enabled = true,
					align = "center",
					rounded = true,
				},
				input = {
					prefix = "> ",
					height = 8,
				},
				edit = {
					border = "rounded",
					start_insert = true,
				},
				ask = {
					floating = false,
					start_insert = true,
					border = "rounded",
					focus_on_apply = "ours",
				},
			},
			highlights = {
				diff = {
					current = "DiffText",
					incoming = "DiffAdd",
				},
			},
			diff = {
				autojump = true,
				list_opener = "copen",
			},
			input = {
				provider = "snacks",
				provider_opts = {
					title = "Avante Input",
					icon = " ",
					placeholder = "Enter your message...",
				},
			},
		})
	end,
}

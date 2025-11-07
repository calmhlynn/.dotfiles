return {
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
		},
		event = "LspAttach",
		opts = {
			backend = "delta",
			backend_opts = {
				delta = {
					args = {
						"--line-numbers",
					},
				},
			},
			picker = {
				"snacks",
				opts = {
					layout = {
						preset = "dropdown",
						layout = {
							backdrop = false,
							row = 5,
							width = 0.6,
							min_width = 80,
							height = 0.8,
							border = "none",
							box = "vertical",
							{ win = "preview", title = "{preview}", height = 0.7, border = true },
							{
								box = "vertical",
								border = true,
								title_pos = "center",
								{ win = "list", border = "none" },
								{ win = "input", height = 1, border = "top" },
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			require("tiny-code-action").setup(opts)
			vim.keymap.set("n", "<leader>ac", function()
				require("tiny-code-action").code_action()
			end, { noremap = true, silent = true })
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"hrsh7th/nvim-cmp",
		},
	},
	{
		"lewis6991/hover.nvim",
		config = function()
			require("hover").setup({
				init = function()
					require("hover.providers.lsp")
					require("hover.providers.diagnostic")
				end,
				preview_opts = {
					border = "single",
				},
				-- Whether the contents of a currently open hover window should be moved
				-- to a :h preview-window when pressing the hover keymap.
				preview_window = false,
				title = true,
				mouse_providers = {
					"LSP",
					"diagnostic",
				},
				mouse_delay = 1000,
			})

			-- Setup keymaps
			vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
			vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
			vim.keymap.set("n", "<C-p>", function()
				require("hover").hover_switch("previous")
			end, { desc = "hover.nvim (previous source)" })
			vim.keymap.set("n", "<C-n>", function()
				require("hover").hover_switch("next")
			end, { desc = "hover.nvim (next source)" })

			-- Mouse support
			vim.keymap.set("n", "<MouseMove>", require("hover").hover_mouse, { desc = "hover.nvim (mouse)" })
			vim.o.mousemoveevent = true
		end,
	},
	{ "NvChad/nvim-colorizer.lua", opts = {
		filetypes = { "*" },
	} },
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
	},
	{
		"nvim-lua/plenary.nvim",
	},
}

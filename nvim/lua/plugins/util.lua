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
	{ "NvChad/nvim-colorizer.lua", opts = {
		filetypes = { "*" },
	} },
}

return {
	{ "NvChad/nvim-colorizer.lua", opts = {
		filetypes = { "*" },
	} },
	{
		"christoomey/vim-tmux-navigator",
		init = function()
			vim.g.tmux_navigator_no_mappings = 1
		end,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
		},
		keys = {
			{ "<C-w><Left>", "<cmd>TmuxNavigateLeft<cr>" },
			{ "<C-w><Down>", "<cmd>TmuxNavigateDown<cr>" },
			{ "<C-w><Up>", "<cmd>TmuxNavigateUp<cr>" },
			{ "<C-w><Right>", "<cmd>TmuxNavigateRight<cr>" },
		},
	},
}

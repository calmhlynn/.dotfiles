local function git_status_files()
	vim.cmd({ cmd = "GFiles", args = { "?" } })
end

return {
	{
		"junegunn/fzf",
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"junegunn/fzf.vim",
		dependencies = {
			"junegunn/fzf",
			"tpope/vim-fugitive",
		},
		cmd = {
			"Files",
			"GFiles",
			"Buffers",
			"BLines",
			"Lines",
			"Windows",
			"Rg",
			"RG",
			"Colors",
			"Changes",
			"Helptags",
			"History",
			"Commands",
			"Maps",
			"Jumps",
			"Commits",
			"BCommits",
		},
		keys = {
			{ "<C-\\>g", "<cmd>RG<CR>", desc = "Grep" },
			{ "<C-\\>f", "<cmd>Files<CR>", desc = "Find files" },
			{
				"<C-\\>F",
				function()
					local saved = vim.env.FZF_DEFAULT_COMMAND
					vim.env.FZF_DEFAULT_COMMAND = "rg --files --hidden --follow --no-ignore --glob '!.git/*'"
					vim.cmd("Files")
					vim.env.FZF_DEFAULT_COMMAND = saved
				end,
				desc = "Find all files (no gitignore)",
			},
			{ "<C-\\>b", "<cmd>Buffers<CR>", desc = "Buffers" },
			{ "<C-\\>h", "<cmd>History:<CR>", desc = "Command History" },
			{ "<C-\\>H", "<cmd>History<CR>", desc = "Recent Files" },
			{ "<C-\\>/", "<cmd>History/<CR>", desc = "Search History" },
			{ "<C-\\>l", "<cmd>BLines<CR>", desc = "Buffer Lines" },
			{ "<C-\\>L", "<cmd>Lines<CR>", desc = "Open Buffer Lines" },
			{ "<C-\\>w", "<cmd>Windows<CR>", desc = "Windows" },
			{ "<C-\\>C", "<cmd>Changes<CR>", desc = "Changes" },
			{ "<C-\\>:", "<cmd>Commands<CR>", desc = "Commands" },
			{ "<C-\\>uC", "<cmd>Colors<CR>", desc = "Colorschemes" },
			{ "<C-\\>k", "<cmd>Maps<CR>", desc = "Keymaps" },
			{ "<C-\\>j", "<cmd>Jumps<CR>", desc = "Jumps" },
			{ "<C-\\>s", git_status_files, desc = "Git Status Files" },
			{ "<C-\\>c", "<cmd>Commits<CR>", desc = "Git Log" },
			{ "<C-\\>lf", "<cmd>BCommits<CR>", desc = "Git Log File" },
		},
		init = function()
			vim.env.FZF_DEFAULT_COMMAND = "rg --files --hidden --follow --glob '!.git/*'"

			vim.g.fzf_layout = {
				window = {
					width = 0.9,
					height = 0.8,
				},
			}
			vim.g.fzf_preview_window = { "right:50%", "ctrl-/" }
		end,
	},
}

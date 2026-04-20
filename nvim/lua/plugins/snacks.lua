require("snacks").setup({
	explorer = {
		enabled = true,
	},
	notifier = {
		enabled = true,
	},
	picker = {
		enabled = true,
		layout = {
			preset = "default",
		},
		layouts = {
			default = {
				layout = {
					box = "horizontal",
					width = 0.8,
					min_width = 120,
					height = 0.8,
					{
						box = "vertical",
						border = true,
						title = "{title} {live} {flags}",
						{ win = "input", height = 1, border = "bottom" },
						{ win = "list", border = "none" },
					},
					{ win = "preview", title = "{preview}", border = true, width = 0.6 },
				},
			},
		},
		previewers = {
			diff = {
				builtin = false,
				cmd = {
					"delta",
					"--paging=never",
				},
			},
		},
		sources = {
			git_log = {
				preview = "git_log",
			},
		},
		actions = {
			sidekick_send = function(...)
				return require("sidekick.cli.picker.snacks").send(...)
			end,
		},
		win = {
			input = {
				keys = {
					["<a-a>"] = {
						"sidekick_send",
						mode = { "n", "i" },
					},
				},
			},
		},
	},
})

vim.api.nvim_create_autocmd("QuitPre", {
	group = vim.api.nvim_create_augroup("snacks_auto_quit", { clear = true }),
	desc = "Close snacks windows before quitting so :q exits cleanly",
	callback = function()
		local snacks_windows = {}
		local floating_windows = {}
		local windows = vim.api.nvim_list_wins()
		for _, w in ipairs(windows) do
			local filetype = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(w) })
			if filetype:match("snacks_") ~= nil then
				table.insert(snacks_windows, w)
			elseif vim.api.nvim_win_get_config(w).relative ~= "" then
				table.insert(floating_windows, w)
			end
		end
		if 1 == #windows - #floating_windows - #snacks_windows then
			for _, w in ipairs(snacks_windows) do
				vim.api.nvim_win_close(w, true)
			end
		end
	end,
})

-- Keymaps (converted from lazy.nvim keys spec)
vim.keymap.set("n", "<Space>s", function() Snacks.explorer() end, { desc = "File Explorer" })
vim.keymap.set("n", "<C-\\>g", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set("n", "<C-\\>f", function() Snacks.picker.files() end, { desc = "Find files" })
vim.keymap.set("n", "<C-\\>F", function()
	Snacks.picker.files({
		hidden = true,
		ignored = true,
		follow = true,
		exclude = { ".git", ".git/*" },
	})
end, { desc = "Find all files (no gitignore)" })
vim.keymap.set("n", "<C-\\>b", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<C-\\>h", function() Snacks.picker.command_history() end, { desc = "Command History" })
vim.keymap.set("n", "<C-\\>H", function() Snacks.picker.recent() end, { desc = "Recent Files" })
vim.keymap.set("n", "<C-\\>/", function() Snacks.picker.search_history() end, { desc = "Search History" })
vim.keymap.set("n", "<C-\\>l", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
vim.keymap.set("n", "<C-\\>:", function() Snacks.picker.commands() end, { desc = "Commands" })
vim.keymap.set("n", "<C-\\>m", function() Snacks.picker.man() end, { desc = "Man Pages" })
vim.keymap.set("n", "<C-\\>S", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
vim.keymap.set("n", "<C-\\>s", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
vim.keymap.set("n", "<C-\\>n", function() Snacks.picker.notifications() end, { desc = "Notification History" })
vim.keymap.set("n", "<C-\\>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
vim.keymap.set("n", "<C-\\>k", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<C-\\>j", function() Snacks.picker.jumps() end, { desc = "Jumps" })
vim.keymap.set("n", "<C-\\>Gs", function() Snacks.picker.git_status() end, { desc = "Git Status Files" })
vim.keymap.set("n", "<C-\\>d", function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
vim.keymap.set("n", "<C-\\>c", function() Snacks.picker.git_log() end, { desc = "Git Log" })
vim.keymap.set("n", "<C-\\>lf", function() Snacks.picker.git_log_file() end, { desc = "Git Log File" })
-- Terminal toggle (built-in)
local term_buf = nil
local term_win = nil
local function toggle_terminal()
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_hide(term_win)
		term_win = nil
		return
	end
	if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
		vim.cmd("botright split")
		term_win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(term_win, term_buf)
	else
		vim.cmd("botright split | terminal")
		term_buf = vim.api.nvim_get_current_buf()
		term_win = vim.api.nvim_get_current_win()
	end
	vim.api.nvim_win_set_height(term_win, math.floor(vim.o.lines * 0.2))
	vim.cmd("startinsert")
end
vim.keymap.set("n", "t", toggle_terminal, { desc = "Terminal Toggle" })
vim.keymap.set("t", "<C-t>", toggle_terminal, { desc = "Terminal Toggle" })
vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]], { desc = "Terminal Normal Mode" })
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "References" })

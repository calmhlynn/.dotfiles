vim.g.mapleader = ";"
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.scrolloff = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wildignorecase = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.ff = "unix"
vim.opt.encoding = "utf-8"
vim.opt.hidden = true
vim.opt.updatetime = 500
vim.opt.redrawtime = 1500
vim.opt.timeout = true
vim.opt.ttimeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 100
vim.opt.cursorline = true
vim.opt.swapfile = false
vim.opt.autoread = true
vim.wo.signcolumn = "yes"
vim.o.ttyfast = true

vim.g.clipboard = {
	name = "OSC 52",
	copy = {
		["+"] = require("vim.ui.clipboard.osc52").copy("+"),
		["*"] = require("vim.ui.clipboard.osc52").copy("*"),
	},
	paste = {
		["+"] = function() end,
		["*"] = function() end,
	},
}

vim.opt.clipboard = "unnamedplus"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	group = vim.api.nvim_create_augroup("auto_reload_file", { clear = true }),
	desc = "Auto reload file when changed externally",
	command = "silent! checktime",
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

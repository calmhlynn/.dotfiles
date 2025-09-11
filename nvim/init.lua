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
vim.wo.signcolumn = "yes"
vim.o.ttyfast = true
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

vim.api.nvim_create_autocmd("WinEnter", {
	group = vim.api.nvim_create_augroup("snacks_auto_quit_all_tabs", { clear = true }),
	pattern = "*",
	desc = "Quit nvim if only special (non-file) buffers remain and no unsaved changes",
	callback = function()
		-- vim.defer_fn to execute after window state stabilizes
		vim.defer_fn(function()
			local real_file_open = false
			local has_modified_buffer = false

			-- 1. Check all buffers first for modified status
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_option(bufnr, "buftype") == "" then
					if vim.api.nvim_buf_get_option(bufnr, "modified") then
						has_modified_buffer = true
						break
					end
				end
			end

			-- 2. Check all tab pages for real files
			for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
				for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
					local bufnr = vim.api.nvim_win_get_buf(win)
					if vim.api.nvim_buf_get_option(bufnr, "buftype") == "" then
						real_file_open = true
						break
					end
				end
				if real_file_open then
					break
				end
			end

			-- 3. Only quit if no real files are open and no modified buffers exist
			if not real_file_open and not has_modified_buffer then
				vim.cmd("qall!")
			end
		end, 50) -- 50ms delay for stability
	end,
})

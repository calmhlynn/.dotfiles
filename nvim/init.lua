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
vim.opt.lazyredraw = true
vim.opt.timeout = true
vim.opt.ttimeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 100
-- vim.o.mousemoveevent = true
-- vim.g.loaded_perl_provider = 0
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
vim.wo.signcolumn = "yes"
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

LSP_ON_ATTACH = function(client, bufnr)
	-- keybind options
	-- local bufopts = { noremap = true, silent = true, buffer = bufnr }

	-- set keybinds
	-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	-- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	-- vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	-- vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, bufopts)
	-- vim.keymap.set("n", "L", "<cmd>Lspsaga show_cursor_diagnostics<CR>", bufopts)
	-- vim.keymap.set("n", "<leader>f", "<cmd>Lspsaga finder<CR>", bufopts)
	-- vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", bufopts)
	-- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
	-- vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	-- vim.keymap.set("n", "<leader>ac", function()
	-- 	require("actions-preview").code_actions()
	-- end, bufopts)
	-- vim.keymap.set("n", "<leader>bf", function()
	-- 	vim.lsp.buf.format()
	-- end, bufopts)

	vim.lsp.inlay_hint.enable(true)
end
-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
})

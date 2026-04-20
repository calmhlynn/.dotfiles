vim.g.mapleader = ";"
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.scrolloff = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wildignorecase = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 500
vim.opt.redrawtime = 1500
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 100
vim.opt.cursorline = true
vim.opt.swapfile = false
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"
vim.opt.shortmess:append("WS")
vim.opt.pumborder = "rounded"
vim.opt.pummaxwidth = 50
vim.opt.cmdheight = 0
vim.g.clipboard = "osc52"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

-- Pre-load plugin configuration (must be set before vim.pack.add)
vim.g.tmux_navigator_no_mappings = 1
vim.g.rustaceanvim = {
	server = {
		on_attach = function(_, bufnr)
			vim.keymap.set("n", "<leader>t", function()
				vim.cmd.RustLsp({ "testables" })
			end, { buffer = bufnr })

			vim.keymap.set("n", "<leader>em", function()
				vim.cmd.RustLsp({ "expandMacro" })
			end, { buffer = bufnr })

			vim.keymap.set("n", "<leader>rp", function()
				vim.cmd.RustLsp({ "rebuildProcMacros" })
			end, { buffer = bufnr })

			vim.keymap.set("n", "<leader>rd", function()
				vim.cmd.RustLsp({ "renderDiagnostic" })
			end, { buffer = bufnr })

			vim.keymap.set("n", "<leader>pm", function()
				vim.cmd.RustLsp({ "parentModule" })
			end, { buffer = bufnr })

			vim.keymap.set("n", "<leader>fc", function()
				vim.cmd.RustLsp({ "flyCheck" })
			end, { buffer = bufnr })

			vim.keymap.set("n", "<leader>c", function()
				vim.cmd.RustLsp({ "openCargo" })
			end, { buffer = bufnr })
		end,
	},
}

-- Build hooks (must be created before vim.pack.add)
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "nvim-treesitter" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

-- Install and load plugins
vim.pack.add({
	"https://github.com/catppuccin/nvim",
	"https://github.com/folke/snacks.nvim",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/williamboman/mason.nvim",
	{ src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("^9") },
	{ src = "https://github.com/saecki/crates.nvim", version = "stable" },
	"https://github.com/NvChad/nvim-colorizer.lua",
	"https://github.com/christoomey/vim-tmux-navigator",
	"https://github.com/nvim-tree/nvim-web-devicons",
	{ src = "https://github.com/akinsho/bufferline.nvim", version = vim.version.range("*") },
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	"https://github.com/windwp/nvim-autopairs",
})

-- Plugin setup (catppuccin must load first)
require("plugins.catppuccin")
require("plugins.snacks")
require("plugins.treesitter")
require("plugins.conform")
require("plugins.gitsigns")
require("plugins.which-key")
require("plugins.mason")
require("plugins.crates")
require("plugins.colorizer")
require("plugins.tmux-navigator")
require("plugins.bufferline")
require("plugins.render-markdown")
require("plugins.autopairs")

-- Core modules
require("lsp")
require("completion")
require("keymaps")
require("statusline").setup()

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
	desc = "Enable built-in Tree-sitter highlighting",
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf)
	end,
})

-- Bigfile: disable heavy features for large files
vim.api.nvim_create_autocmd("BufReadPre", {
	group = vim.api.nvim_create_augroup("bigfile", { clear = true }),
	desc = "Disable heavy features for large files",
	callback = function(ev)
		local max_filesize = 1024 * 1024 -- 1MB
		local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
		if ok and stats and stats.size > max_filesize then
			vim.bo[ev.buf].syntax = ""
			vim.bo[ev.buf].swapfile = false
			vim.bo[ev.buf].undolevels = -1
			vim.b[ev.buf].bigfile = true
		end
	end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	group = vim.api.nvim_create_augroup("auto_reload_file", { clear = true }),
	desc = "Auto reload file when changed externally",
	command = "silent! checktime",
})

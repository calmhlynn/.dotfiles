vim.g.mapleader = ";"
vim.g.loaded_nvim_dir_plugin = 1
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
vim.opt.termguicolors = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 99

if vim.fn.has("nvim-0.13") == 1 then
	-- Keep the cursor centered at the end of the file, which 'scrolloff' alone
	-- cannot do. Added in Nvim 0.13.
	vim.opt.scrolloffpad = 999
end

-- Over SSH the OSC52 provider can only write, so cache what we copy to make
-- the matching paste work inside this session.
if vim.env.SSH_CONNECTION then
	local osc52 = require("vim.ui.clipboard.osc52")
	local clip_cache = { ["+"] = { { "" }, "v" }, ["*"] = { { "" }, "v" } }
	local function osc52_copy(reg)
		local base = osc52.copy(reg)
		return function(lines, regtype)
			clip_cache[reg] = { lines, regtype }
			base(lines, regtype)
		end
	end
	local function cached_paste(reg)
		return function()
			return clip_cache[reg]
		end
	end
	vim.g.clipboard = {
		name = "osc52-copy-only",
		copy = { ["+"] = osc52_copy("+"), ["*"] = osc52_copy("*") },
		paste = { ["+"] = cached_paste("+"), ["*"] = cached_paste("*") },
	}
end

vim.opt.clipboard = "unnamedplus"

vim.g.tmux_navigator_no_mappings = 1
vim.g.rustaceanvim = {
	server = {
		default_settings = {
			["rust-analyzer"] = {
				files = {
					watcher = "client",
					exclude = { "target", ".git" },
				},
				checkOnSave = true,
				check = {
					command = "clippy",
					extraArgs = { "--no-deps" },
				},
				cargo = {
					targetDir = true,
					features = "all",
				},
			},
		},
		lspmux = { enable = false },
		on_attach = function(_, bufnr)
			vim.keymap.set("n", "<leader>tt", function()
				vim.cmd.RustLsp({ "testables" })
			end, { buffer = bufnr, desc = "Rust Testables" })

			vim.keymap.set("n", "<leader>em", function()
				vim.cmd.RustLsp({ "expandMacro" })
			end, { buffer = bufnr, desc = "Rust Expand Macro" })

			vim.keymap.set("n", "<leader>rp", function()
				vim.cmd.RustLsp({ "rebuildProcMacros" })
			end, { buffer = bufnr, desc = "Rust Rebuild Proc Macros" })

			vim.keymap.set("n", "<leader>rd", function()
				vim.cmd.RustLsp({ "renderDiagnostic" })
			end, { buffer = bufnr, desc = "Rust Render Diagnostic" })

			vim.keymap.set("n", "<leader>mp", function()
				vim.cmd.RustLsp({ "parentModule" })
			end, { buffer = bufnr, desc = "Rust Parent Module" })

			vim.keymap.set("n", "<leader>fc", function()
				vim.cmd.RustLsp({ "flyCheck" })
			end, { buffer = bufnr, desc = "Rust Fly Check" })

			vim.keymap.set("n", "<leader>co", function()
				vim.cmd.RustLsp({ "openCargo" })
			end, { buffer = bufnr, desc = "Rust Open Cargo.toml" })
		end,
	},
}

vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("pack_treesitter_update", { clear = true }),
	desc = "Run TSUpdate when nvim-treesitter changes",
	callback = function(ev)
		if ev.data.spec.name == "nvim-treesitter" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	"https://github.com/folke/snacks.nvim",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/williamboman/mason.nvim",
	{ src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("^9") },
	{ src = "https://github.com/saecki/crates.nvim", version = "stable" },
	"https://github.com/christoomey/vim-tmux-navigator",
	"https://github.com/nvim-tree/nvim-web-devicons",
	{ src = "https://github.com/akinsho/bufferline.nvim", version = vim.version.range("*") },
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	"https://github.com/windwp/nvim-autopairs",
})

require("plugins.catppuccin")
require("plugins.snacks")
require("plugins.treesitter")
require("plugins.conform")
require("plugins.gitsigns")
require("plugins.which-key")
require("plugins.mason")
require("plugins.crates")
require("plugins.tmux-navigator")
require("plugins.bufferline")
require("plugins.render-markdown")
require("plugins.autopairs")

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

-- Setup plugin manager
require("plugins.plugin_setup")

-- Settings
vim.g.mapleader = ";"
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wildignorecase = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.ff = "unix"
vim.opt.scrolloff = 4
vim.opt.encoding = "utf-8"
vim.opt.hidden = true
vim.opt.updatetime = 500
vim.opt.redrawtime = 1500
vim.opt.lazyredraw = true
vim.opt.timeout = true
vim.opt.ttimeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 100
vim.g.loaded_perl_provider = 0
vim.wo.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
-- vim.cmd([[language en_US]])

-- LSPs
require("plugins.lsp.lsp")
require("plugins.lsp.yaml")
require("plugins.lsp.lua")
require("plugins.lsp.python")
require("plugins.lsp.rust")
require("plugins.lsp.c")
-- require("plugins.lsp.zig")
-- require("plugins.lsp.typescript")
-- require("plugins.lsp.terraform")

-- Plugins
require("plugins.auto_session")
require("plugins.autopairs")
require("plugins.avante")
require("plugins.bufferline")
require("plugins.comment")
require("plugins.conform")
-- require("plugins.dap")
require("plugins.gitsigns")
require("plugins.kanagawa")
require("plugins.lualine")
require("plugins.markdown")
require("plugins.mason")
require("plugins.notify")
require("plugins.nvim_cmp")
require("plugins.nvim_tree")
require("plugins.telescope")
require("plugins.toggleterm")
require("plugins.treesitter")
require("plugins.trouble")
require("plugins.util")

-- Filetypes
require("filetypes.c")
-- require("filetypes.markdown")
-- require("filetypes.javascript")

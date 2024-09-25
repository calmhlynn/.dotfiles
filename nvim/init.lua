-- Setup Lazy plugin manager

require("plugins.plugin_setup")

-- Settings

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
vim.opt.updatetime = 300
vim.g.loaded_perl_provider = 0
vim.wo.signcolumn = "yes"
vim.cmd([[language en_US]])

-- (Global) Key mappings

vim.g.mapleader = ";"
vim.cmd([[
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k
]])
-- vim.keymap.set("i", ";;", "<Esc>", { silent = true, noremap = true})

-- Workaround for notify.nvim
-- https://github.com/rcarriga/nvim-notify/issues/63
vim.opt.updatetime = 500
vim.opt.redrawtime = 1500
vim.opt.lazyredraw = true
vim.opt.timeout = true
vim.opt.ttimeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10

-- Plugins

require("plugins.auto_session")
require("plugins.telescope")
require("plugins.nvim_tree")
require("plugins.nvim_cmp")
require("plugins.lualine")
require("plugins.treesitter")
require("plugins.toggleterm")
require("plugins.autopairs")
require("plugins.trouble")
require("plugins.bufferline")
require("plugins.gitsigns")
require("plugins.notify")
require("plugins.neogit")
require("plugins.conform")
-- require("plugins.chatgpt")
require("plugins.mason")
require("plugins.comment")
require("plugins.markdown")

require("plugins.lsp.lsp")
-- require("plugins.lsp.rust")
-- require("plugins.lsp.zig")
-- require("plugins.lsp.typescript")
require("plugins.lsp.lua")
require("plugins.lsp.python")
require("plugins.lsp.cpp")
-- require("plugins.lsp.terraform")
-- require("plugins.lsp.scala")
-- require("plugins.lsp.go")

-- Filetypes

require("filetypes.markdown")
-- require("filetypes.javascript")
-- require("filetypes.graphql")
-- require("filetypes.prisma")

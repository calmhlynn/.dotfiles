-- Functional wrapper for mapping custom keybindings
function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Configuration for nvim-colorizer.lua
require("colorizer").setup({
	filetypes = { "*" },
})

-- Configuration for indent-blankline.nvim
local hooks = require("ibl.hooks")
local highlight = {
	"RainbowRed",
	"RainbowYellow",
	"RainbowBlue",
	"RainbowOrange",
	"RainbowGreen",
	"RainbowViolet",
	"RainbowCyan",
}
-- colorscheme based on kanagawa-dragon
-- https://github.com/rebelot/kanagawa.nvim
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#c4746e" })
	vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#c4b28a" })
	vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#8ba4b0" })
	vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#b6927b" })
	vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#8a9a7b" })
	vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#9288b0" })
	vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#8ea4a2" })
end)

vim.g.rainbow_delimiters = { highlight = highlight }
require("ibl").setup({ indent = { highlight = highlight } })
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

-- This code addresses the issue of duplicate spaces when typing in Korean.
local last_space_time = 0
function _G.smart_space()
	local now = vim.loop.hrtime() / 1e6
	if now - last_space_time < 50 then
		return ""
	else
		last_space_time = now
		return " "
	end
end
vim.api.nvim_set_keymap("i", "<Space>", "v:lua.smart_space()", { expr = true, noremap = true })

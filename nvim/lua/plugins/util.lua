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

-- -- this feature requires nvim versions >= 0.11
-- vim.diagnostic.config({
-- 	virtual_lines = true,
--
--     virtual_lines = {
--         current_line = true,
--     },
-- })

local parsers = {
	"rust",
	"c",
	"cpp",
	"cuda",
	"toml",
	"lua",
	"json",
	"javascript",
	"python",
	"typescript",
	"tsx",
	"yaml",
	"html",
	"css",
	"markdown",
	"markdown_inline",
	"graphql",
	"bash",
	"vim",
	"vimdoc",
	"dockerfile",
	"regex",
	"gitignore",
	"diff",
	"zig",
	"just",
}

local ts = require("nvim-treesitter")
ts.setup({})

local installed = ts.get_installed("parsers")
local missing = vim.tbl_filter(function(lang)
	return not vim.list_contains(installed, lang)
end, parsers)

if #missing > 0 then
	local handle = ts.install(missing)
	if vim.list_contains(vim.v.argv, "--headless") then
		handle:wait(300000)
	end
end

local parsers = {
	"rust",
	"c",
	"cpp",
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

require("nvim-treesitter").setup({})

vim.api.nvim_create_user_command("TSInstallConfigured", function()
	require("nvim-treesitter").install(parsers)
end, { desc = "Install configured Tree-sitter parsers" })

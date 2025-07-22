return {

	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			modules = {}, -- Add missing field
			sync_install = false, -- Add missing field
			ignore_install = {}, -- Add missing field
			-- enable syntax highlighting
			highlight = {
				enable = true,
			},
			-- enable indentation
			indent = { enable = true },
			-- enable autotagging (w/ nvim-ts-autotag plugin)
			autotag = {
				enable = true,
			},
			-- ensure these language parsers are installed
			ensure_installed = {
				"rust",
				"c",
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
				"dockerfile",
				"regex",
				"gitignore",
				"diff",
				"zig",
			},
			-- auto install above language parsers
			auto_install = true,
			rainbow = {
				enable = true,
				extended_mode = true,
				max_file_lines = nil,
			},
		})
		vim.keymap.set(
			"n",
			"<leader>rr",
			"<Cmd>TSDisable rainbow|TSEnable rainbow<CR>",
			{ desc = "Toggle Treesitter Rainbow" }
		)
	end,
}

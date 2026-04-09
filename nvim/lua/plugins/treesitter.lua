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

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({})

		vim.api.nvim_create_user_command("TSInstallConfigured", function()
			require("nvim-treesitter").install(parsers)
		end, { desc = "Install configured Tree-sitter parsers" })

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter_enable", { clear = true }),
			callback = function(ev)
				if vim.bo[ev.buf].filetype == "rust" then
					vim.bo[ev.buf].syntax = "rust"
					return
				end

				pcall(vim.treesitter.start, ev.buf)

				local ok, lang = pcall(vim.treesitter.language.get_lang, vim.bo[ev.buf].filetype)
				if not ok or not lang then
					return
				end

				local has_indent_query, query = pcall(vim.treesitter.query.get, lang, "indents")
				if has_indent_query and query then
					vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
			desc = "Enable Tree-sitter for supported filetypes",
		})
	end,
}

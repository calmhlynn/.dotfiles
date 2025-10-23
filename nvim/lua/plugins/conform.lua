return {
	"stevearc/conform.nvim",
	opts = {

		formatters_by_ft = {
			lua = { "stylua" },
			rust = { "rustfmt" },
			c = { "clang-format" },
			cuda = { "clang-format" },
			python = { "black" },
		},
		formatters = {
			["clang-format"] = {
				args = { "--style={BasedOnStyle: 'LLVM', IndentWidth: 4, ColumnLimit: 140}" },
			},
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}

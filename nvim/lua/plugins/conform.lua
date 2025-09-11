return {
	"stevearc/conform.nvim",
	opts = {

		formatters_by_ft = {
			lua = { "stylua" },
			c = { "clang-format" },
			cuda = { "clang-format" },
			python = { "black" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			["*"] = { "trim_whitespace" },
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

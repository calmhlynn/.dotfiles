return {
	"stevearc/conform.nvim",
	opts = {

		formatters_by_ft = {
			lua = { "stylua" },
			c = { "clang-format" },
			python = { "black" },
		},
		formatters = {
			["clang-format"] = {
				args = { "--style={ColumnLimit: 150}" },
			},
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}

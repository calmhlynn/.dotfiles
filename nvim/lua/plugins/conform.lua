require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		c = { "clang-format" },
	},
	formatters = {
		["clang-format"] = {
			args = { "--style='{ColumnLimit: 150}'" },
		},
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

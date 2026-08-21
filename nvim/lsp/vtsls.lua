return {
	cmd = require("lsp.util").node_cmd("vtsls"),
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	workspace_required = true,
	settings = {
		typescript = {
			format = {
				semicolons = "remove",
				insertSpaceBeforeFunctionParenthesis = true,
			},
		},
		javascript = {
			format = {
				semicolons = "remove",
				insertSpaceBeforeFunctionParenthesis = true,
			},
		},
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
}

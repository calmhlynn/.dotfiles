local lspconfig = require("lspconfig")
local null_ls = require("null-ls")

local on_attach = function(client, bufnr)
	LSP_ON_ATTACH(client, bufnr)
end

-- TypeScript
lspconfig["tsserver"].setup({
	on_attach = on_attach,
	root_dir = lspconfig.util.root_pattern("package.json"),
	cmd = { "pnpm", "typescript-language-server", "--stdio" },
	single_file_support = false,
	settings = {
		typescript = {
			enable = true,
			format = {
				semicolons = "remove",
			},
			insertSpaceAfterCommaDelimiter = true,
			insertSpaceAfterSemicolonInForStatements = true,
			insertSpaceBeforeAndAfterBinaryOperators = true,
			insertSpaceAfterKeywordsInControlFlowStatements = true,
			insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
			insertSpaceBeforeFunctionParenthesis = true,
		},
		javascript = {
			enable = true,
			format = {
				semicolons = "remove",
			},
			insertSpaceAfterCommaDelimiter = true,
			insertSpaceAfterSemicolonInForStatements = true,
			insertSpaceBeforeAndAfterBinaryOperators = true,
			insertSpaceAfterKeywordsInControlFlowStatements = true,
			insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
			insertSpaceBeforeFunctionParenthesis = true,
		},
	},
})

-- ESLint
lspconfig["eslint"].setup({
	on_attach = on_attach,
})

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettier,
	},
})

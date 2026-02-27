return {
	"neovim/nvim-lspconfig",
	config = function()
		vim.diagnostic.config({
			virtual_text = true,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		-- C & CPP
		vim.lsp.config("clangd", {})
		-- vim.api.nvim_create_autocmd("FileType", {
		-- 	pattern = { "c", "cpp", "objc", "objcpp" },
		-- 	callback = function()
		-- 		-- Set indentation settings for C/C++ files
		-- 		vim.bo.tabstop = 2
		-- 		vim.bo.shiftwidth = 2
		-- 		vim.bo.expandtab = true -- Use spaces instead of tabs
		-- 	end,
		-- })

		-- python
		vim.lsp.config("pyright", {})

		-- JavaScript
		vim.lsp.config("eslint", {})
		vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
			group = vim.api.nvim_create_augroup("javascript_sw_is_2", { clear = true }),
			pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "jsonc" },
			command = "setlocal shiftwidth=2",
		})

		-- TypeScript
		vim.lsp.config("tsserver", {
			root_dir = require("lspconfig").util.root_pattern("package.json"),
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
			filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
		})

		vim.lsp.config("tailwindcss", {
			settings = {
				tailwindCSS = {
					classAttributes = { "class", "className", "classList", "ngClass" },
					lint = {
						cssConflict = "warning",
						invalidApply = "error",
						invalidConfigPath = "error",
						invalidScreen = "error",
						invalidTailwindDirective = "error",
						invalidVariant = "error",
						recommendedVariantOrder = "warning",
					},
					validate = true,
					colorDecorators = true,
				},
			},
		})

		-- Lua
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})

		-- Markdown
		-- vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
		-- 	group = vim.api.nvim_create_augroup("markdown_sw_is_2", { clear = true }),
		-- 	pattern = "markdown",
		-- 	command = "setlocal shiftwidth=2",
		-- })

		vim.api.nvim_create_autocmd({ "FileType" }, {
			group = vim.api.nvim_create_augroup("markdown_wrap", { clear = true }),
			pattern = "markdown",
			command = "set wrap | set textwidth=80",
		})
	end,
}

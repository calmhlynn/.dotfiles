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

		local on_attach = function(client, bufnr)
			vim.schedule(function()
				pcall(function()
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end)
			end)

			vim.keymap.set("n", "[[", "<C-o>", { buffer = bufnr, desc = "Go to Older Position in Jumplist" })
			vim.keymap.set("n", "]]", "<C-i>", { buffer = bufnr, desc = "Go to Newer Position in Jumplist" })

			-- Diagnostic navigation
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next Diagnostic" })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Previous Diagnostic" })

			-- Jump to next/previous error only
			vim.keymap.set("n", "]e", function()
				vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
			end, { buffer = bufnr, desc = "Next Error" })
			vim.keymap.set("n", "[e", function()
				vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
			end, { buffer = bufnr, desc = "Previous Error" })

			-- Jump to next/previous warning only
			vim.keymap.set("n", "]w", function()
				vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
			end, { buffer = bufnr, desc = "Next Warning" })
			vim.keymap.set("n", "[w", function()
				vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
			end, { buffer = bufnr, desc = "Previous Warning" })

			-- Show diagnostic in floating window
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = bufnr, desc = "Show Diagnostic" })
		end

		-- C & CPP
		vim.lsp.config("clangd", {
			on_attach = on_attach,
		})
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
		vim.lsp.config("pyright", {
			on_attach = on_attach,
		})

		-- JavaScript
		vim.lsp.config("eslint", {
			on_attach = on_attach,
		})
		vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
			group = vim.api.nvim_create_augroup("javascript_sw_is_2", { clear = true }),
			pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "jsonc" },
			command = "setlocal shiftwidth=2",
		})

		-- TypeScript
		vim.lsp.config("tsserver", {
			on_attach = on_attach,
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
			on_attach = on_attach,
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
			on_attach = on_attach,
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

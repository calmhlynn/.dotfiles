return {
	"neovim/nvim-lspconfig",
	config = function()
		local lsp_float = {
			border = "rounded",
			focusable = true,
			max_width = 80,
			max_height = 20,
			silent = false,
			wrap = true,
		}

		vim.diagnostic.config({
			virtual_text = false,
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
			root_markers = { "package.json" },
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

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp_rust_codelens", { clear = true }),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if not client or vim.bo[ev.buf].filetype ~= "rust" then
					return
				end
				if not client:supports_method("textDocument/codeLens") then
					return
				end

				vim.lsp.codelens.enable(true, { bufnr = ev.buf })
				vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
					group = vim.api.nvim_create_augroup("lsp_rust_codelens_" .. ev.buf, { clear = true }),
					buffer = ev.buf,
					callback = function()
						vim.lsp.codelens.refresh({ bufnr = ev.buf })
					end,
					desc = "Refresh Rust code lenses",
				})
			end,
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp_float_keymaps", { clear = true }),
			callback = function(ev)
				local opts = { buf = ev.buf }

				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover(lsp_float)
				end, vim.tbl_extend("force", opts, { desc = "LSP Hover" }))
				vim.keymap.set("n", "gK", function()
					vim.lsp.buf.signature_help(lsp_float)
				end, vim.tbl_extend("force", opts, { desc = "LSP Signature Help" }))

				end,
		})

		vim.lsp.enable({ "clangd", "pyright", "eslint", "tsserver", "tailwindcss", "lua_ls" })
	end,
}

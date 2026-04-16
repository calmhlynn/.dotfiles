-- Helper: prefer project-local node_modules binary over global
local function node_cmd(binary)
	return function(dispatchers, config)
		local cmd = binary
		if (config or {}).root_dir then
			local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", binary)
			if vim.fn.executable(local_cmd) == 1 then
				cmd = local_cmd
			end
		end
		return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
	end
end

-- C / C++
vim.lsp.config("clangd", {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
	root_markers = {
		".clangd", ".clang-tidy", ".clang-format",
		"compile_commands.json", "compile_flags.txt", "configure.ac", ".git",
	},
	get_language_id = function(_, ftype)
		return ({ objc = "objective-c", objcpp = "objective-cpp", cuda = "cuda-cpp" })[ftype] or ftype
	end,
	capabilities = {
		textDocument = { completion = { editsNearCursor = true } },
		offsetEncoding = { "utf-8", "utf-16" },
	},
	on_init = function(client, init_result)
		if init_result.offsetEncoding then
			client.offset_encoding = init_result.offsetEncoding
		end
	end,
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspClangdSwitchSourceHeader", function()
			local method = "textDocument/switchSourceHeader"
			if not client:supports_method(method) then
				vim.notify("method " .. method .. " is not supported")
				return
			end
			client:request(method, vim.lsp.util.make_text_document_params(bufnr), function(err, result)
				if err then
					error(tostring(err))
				end
				if result then
					vim.cmd.edit(vim.uri_to_fname(result))
				end
			end, bufnr)
		end, { desc = "Switch between source/header" })
	end,
})

-- Python
vim.lsp.config("pyright", {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		"pyrightconfig.json", "pyproject.toml", "setup.py",
		"setup.cfg", "requirements.txt", "Pipfile", ".git",
	},
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
			},
		},
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightOrganizeImports", function()
			client.request("workspace/executeCommand", {
				command = "pyright.organizeimports",
				arguments = { vim.uri_from_bufnr(bufnr) },
			}, nil, bufnr)
		end, { desc = "Organize Imports" })
	end,
})

-- ESLint
vim.lsp.config("eslint", {
	cmd = node_cmd("vscode-eslint-language-server"),
	filetypes = {
		"javascript", "javascriptreact",
		"typescript", "typescriptreact",
		"vue", "svelte", "astro", "htmlangular",
	},
	root_markers = {
		"package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock",
		".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json",
		"eslint.config.js", "eslint.config.mjs", "eslint.config.cjs",
		"eslint.config.ts", "eslint.config.mts", "eslint.config.cts",
		".git",
	},
	workspace_required = true,
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspEslintFixAll", function()
			client:request_sync("workspace/executeCommand", {
				command = "eslint.applyAllFixes",
				arguments = { {
					uri = vim.uri_from_bufnr(bufnr),
					version = vim.lsp.util.buf_versions[bufnr],
				} },
			}, nil, bufnr)
		end, {})
	end,
	before_init = function(_, config)
		if config.root_dir then
			config.settings = config.settings or {}
			config.settings.workspaceFolder = {
				uri = config.root_dir,
				name = vim.fn.fnamemodify(config.root_dir, ":t"),
			}
		end
	end,
	settings = {
		validate = "on",
		useESLintClass = false,
		experimental = {},
		codeActionOnSave = { enable = false, mode = "all" },
		format = true,
		quiet = false,
		onIgnoredFiles = "off",
		rulesCustomizations = {},
		run = "onType",
		problems = { shortenToSingleLine = false },
		nodePath = "",
		workingDirectory = { mode = "auto" },
		codeAction = {
			disableRuleComment = { enable = true, location = "separateLine" },
			showDocumentation = { enable = true },
		},
	},
	handlers = {
		["eslint/openDoc"] = function(_, result)
			if result then
				vim.ui.open(result.url)
			end
			return {}
		end,
		["eslint/confirmESLintExecution"] = function(_, result)
			if not result then
				return
			end
			return 4
		end,
		["eslint/probeFailed"] = function()
			vim.notify("[lsp] ESLint probe failed.", vim.log.levels.WARN)
			return {}
		end,
		["eslint/noLibrary"] = function()
			vim.notify("[lsp] Unable to find ESLint library.", vim.log.levels.WARN)
			return {}
		end,
	},
})

-- TypeScript
vim.lsp.config("tsserver", {
	root_markers = { "package.json" },
	cmd = { "pnpm", "typescript-language-server", "--stdio" },
	single_file_support = false,
	settings = {
		typescript = {
			enable = true,
			format = { semicolons = "remove" },
			insertSpaceAfterCommaDelimiter = true,
			insertSpaceAfterSemicolonInForStatements = true,
			insertSpaceBeforeAndAfterBinaryOperators = true,
			insertSpaceAfterKeywordsInControlFlowStatements = true,
			insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
			insertSpaceBeforeFunctionParenthesis = true,
		},
		javascript = {
			enable = true,
			format = { semicolons = "remove" },
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

-- TailwindCSS
vim.lsp.config("tailwindcss", {
	cmd = node_cmd("tailwindcss-language-server"),
	filetypes = {
		"html", "css", "scss", "sass", "less", "postcss",
		"javascript", "javascriptreact", "typescript", "typescriptreact",
		"vue", "svelte", "astro", "markdown", "mdx",
	},
	root_markers = {
		"tailwind.config.js", "tailwind.config.cjs",
		"tailwind.config.mjs", "tailwind.config.ts",
		"postcss.config.js", "postcss.config.cjs",
		"postcss.config.mjs", "postcss.config.ts",
		".git",
	},
	capabilities = {
		workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
	},
	workspace_required = true,
	before_init = function(_, config)
		config.settings = vim.tbl_deep_extend("keep", config.settings or {}, {
			editor = { tabSize = vim.lsp.util.get_effective_tabstop() },
		})
	end,
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
local lua_rm1 = { ".emmyrc.json", ".luarc.json", ".luarc.jsonc" }
local lua_rm2 = { ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml" }
vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = vim.fn.has("nvim-0.11.3") == 1
		and { lua_rm1, lua_rm2, { ".git" } }
		or vim.list_extend(vim.list_extend(lua_rm1, lua_rm2), { ".git" }),
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
})

vim.lsp.enable({ "clangd", "pyright", "eslint", "tsserver", "tailwindcss", "lua_ls" })

-- Diagnostics
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("javascript_sw_is_2", { clear = true }),
	pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "jsonc" },
	command = "setlocal shiftwidth=2",
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("markdown_wrap", { clear = true }),
	pattern = "markdown",
	command = "set wrap | set textwidth=80",
})

local lsp_float = { border = "rounded", focusable = true, max_width = 80, max_height = 20, silent = false, wrap = true }

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_float_keymaps", { clear = true }),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover(lsp_float)
		end, vim.tbl_extend("force", opts, { desc = "LSP Hover" }))
		vim.keymap.set("n", "gK", function()
			vim.lsp.buf.signature_help(lsp_float)
		end, vim.tbl_extend("force", opts, { desc = "LSP Signature Help" }))
	end,
})

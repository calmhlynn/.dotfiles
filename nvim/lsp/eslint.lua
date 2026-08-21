-- NOTE: the settings below are NOT server-default restatements. The eslint
-- server reads them from the client without defensive fallbacks, so removing
-- keys here can silently disable linting. Leave them alone.
return {
	cmd = require("lsp.util").node_cmd("vscode-eslint-language-server"),
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"astro",
		"htmlangular",
	},
	root_markers = {
		"package-lock.json",
		"yarn.lock",
		"pnpm-lock.yaml",
		"bun.lockb",
		"bun.lock",
		".eslintrc",
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.json",
		"eslint.config.js",
		"eslint.config.mjs",
		"eslint.config.cjs",
		"eslint.config.ts",
		"eslint.config.mts",
		"eslint.config.cts",
		".git",
	},
	workspace_required = true,
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspEslintFixAll", function()
			client:request_sync("workspace/executeCommand", {
				command = "eslint.applyAllFixes",
				arguments = {
					{
						uri = vim.uri_from_bufnr(bufnr),
						version = vim.lsp.util.buf_versions[bufnr],
					},
				},
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
}

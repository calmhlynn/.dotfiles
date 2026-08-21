return {
	cmd = require("lsp.util").node_cmd("tailwindcss-language-server"),
	filetypes = {
		"html",
		"css",
		"scss",
		"sass",
		"less",
		"postcss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"astro",
		"markdown",
		"mdx",
	},
	root_markers = {
		"tailwind.config.js",
		"tailwind.config.cjs",
		"tailwind.config.mjs",
		"tailwind.config.ts",
		"postcss.config.js",
		"postcss.config.cjs",
		"postcss.config.mjs",
		"postcss.config.ts",
		"package.json",
		"tsconfig.json",
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
			validate = true,
			colorDecorators = true,
		},
	},
}

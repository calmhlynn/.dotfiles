local lspconfig = require("lspconfig")

lspconfig.yamlls.setup({})
-- ({
-- 	on_attach = LSP_ON_ATTACH,
-- 	settings = {
-- 		yaml = {
-- 			schemaStore = {
-- 				enable = false,
-- 				url = "",
-- 			},
-- 			schemas = {
-- 				-- kubernetes = "*.yaml",
-- 				["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
-- 				["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
-- 				["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/**/*.{yml,yaml}",
-- 				["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
-- 				["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
-- 				["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
-- 				["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
-- 			},
-- 		},
-- 	},
-- })

lspconfig.helm_ls.setup({
	on_attach = LSP_ON_ATTACH,
	settings = {
		["helm-ls"] = {
			yamlls = {
				path = "yaml-language-server",
			},
		},
	},
})

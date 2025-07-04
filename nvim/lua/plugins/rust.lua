return {
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		lazy = false,

		server = {
			on_attach = function(client, bufnr)
				LSP_ON_ATTACH(client, bufnr)
			end,
		},
		keys = {
			{
				"n",
				"<leader>d",
				function()
					vim.cmd.RustLsp({ "debuggables" })
				end,
				desc = "RustLsp debuggables",
				ft = "rust",
			},
			{
				"n",
				"<leader>t",
				function()
					vim.cmd.RustLsp({ "testables" })
				end,
				desc = "RustLsp testables",
				ft = "rust",
			},
			{
				"n",
				"<leader>em",
				function()
					vim.cmd.RustLsp({ "expandMacro" })
				end,
				desc = "RustLsp expandMacro",
				ft = "rust",
			},
			{
				"n",
				"<leader>rp",
				function()
					vim.cmd.RustLsp({ "rebuildProcMacros" })
				end,
				desc = "RustLsp rebuildProcMacros",
				ft = "rust",
			},
			{
				"n",
				"<leader>rd",
				function()
					vim.cmd.RustLsp({ "renderDiagnostic" })
				end,
				desc = "RustLsp renderDiagnostic",
				ft = "rust",
			},
			{
				"n",
				"<leader>pm",
				function()
					vim.cmd.RustLsp({ "parentModule" })
				end,
				desc = "RustLsp parentModule",
				ft = "rust",
			},
			{
				"n",
				"<leader>fc",
				function()
					vim.cmd.RustLsp({ "flyCheck" })
				end,
				desc = "RustLsp flyCheck",
				ft = "rust",
			},
			{
				"n",
				"<leader>c",
				function()
					vim.cmd.RustLsp({ "openCargo" })
				end,
				desc = "RustLsp openCargo",
				ft = "rust",
			},
		},
	},
	{
		"saecki/crates.nvim",
		tag = "stable",

		lsp = {
			enabled = true,
			on_attach = LSP_ON_ATTACH,
			actions = true,
			completion = true,
			hover = true,
		},

		completion = {
			crates = {
				enabled = true,
				max_results = 8,
				min_chars = 3,
			},
		},
		keys = {
			{ "n", "<Leader>cf", ":Crates show_features_popup<CR>", desc = "Crates show features popup" },
			{ "n", "<Leader>cp", ":Crates focus_popup<CR>", desc = "Crates focus popup" },
		},
	},
}

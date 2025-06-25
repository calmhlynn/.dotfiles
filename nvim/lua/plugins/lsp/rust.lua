-- others lsp settings. --
vim.g.rustaceanvim = function()
	return {
		-- other rustacean settings. --
		server = {
			on_attach = function(client, bufnr)
				LSP_ON_ATTACH(client, bufnr)

				vim.keymap.set("n", "<leader>d", function()
					vim.cmd.RustLsp({ "debuggables" })
				end, { buffer = bufnr })

				vim.keymap.set("n", "<leader>t", function()
					vim.cmd.RustLsp({ "testables" })
				end, { buffer = bufnr })

				vim.keymap.set("n", "<leader>em", function()
					vim.cmd.RustLsp({ "expandMacro" })
				end, { buffer = bufnr })

				vim.keymap.set("n", "<leader>rp", function()
					vim.cmd.RustLsp({ "rebuildProcMacros" })
				end, { buffer = bufnr })

				vim.keymap.set("n", "<leader>rd", function()
					vim.cmd.RustLsp({ "renderDiagnostic" })
				end, { buffer = bufnr })

				vim.keymap.set("n", "<leader>pm", function()
					vim.cmd.RustLsp({ "parentModule" })
				end, { buffer = bufnr })

				vim.keymap.set("n", "<leader>fc", function()
					vim.cmd.RustLsp({ "flyCheck" })
				end, { buffer = bufnr })

				vim.keymap.set("n", "<leader>c", function()
					vim.cmd.RustLsp({ "openCargo" })
				end, { buffer = bufnr })
			end,
		},
	}
end

require("crates").setup({
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
})

vim.keymap.set("n", "<Leader>cf", ":Crates show_features_popup<CR>", { silent = true })
vim.keymap.set("n", "<Leader>cp", ":Crates focus_popup<CR>", { silent = true })

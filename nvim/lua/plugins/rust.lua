return {
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		lazy = false,
		init = function()
			vim.g.rustaceanvim = {
				server = {
					cmd = function()
						return { "lspmux", "client", "--server-path", "rust-analyzer" }
					end,
					on_attach = function(client, bufnr)
						-- General LSP keymaps (copied from lsp.lua)
						vim.schedule(function()
							pcall(function()
								vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
							end)
						end)

						vim.keymap.set(
							"n",
							"[[",
							"<C-o>",
							{ buffer = bufnr, desc = "Go to Older Position in Jumplist" }
						)
						vim.keymap.set(
							"n",
							"]]",
							"<C-i>",
							{ buffer = bufnr, desc = "Go to Newer Position in Jumplist" }
						)

						-- Diagnostic navigation
						vim.keymap.set(
							"n",
							"]d",
							vim.diagnostic.goto_next,
							{ buffer = bufnr, desc = "Next Diagnostic" }
						)
						vim.keymap.set(
							"n",
							"[d",
							vim.diagnostic.goto_prev,
							{ buffer = bufnr, desc = "Previous Diagnostic" }
						)

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
						vim.keymap.set(
							"n",
							"<leader>e",
							vim.diagnostic.open_float,
							{ buffer = bufnr, desc = "Show Diagnostic" }
						)

						-- Rust specific keymaps
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
		end,
	},
	{
		"saecki/crates.nvim",
		tag = "stable",

		config = function()
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
			vim.keymap.set(
				"n",
				"<Leader>cf",
				":Crates show_features_popup<CR>",
				{ desc = "Crates show features popup" }
			)
			vim.keymap.set("n", "<Leader>cp", ":Crates focus_popup<CR>", { desc = "Crates focus popup" })
		end,
	},
}


-- enable keybinds only for when lsp server available
LSP_ON_ATTACH = function(client, bufnr)
	-- keybind options
	local bufopts = { noremap = true, silent = true, buffer = bufnr }

	-- set keybinds
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, bufopts)
	-- vim.keymap.set("n", "L", "<cmd>Lspsaga show_cursor_diagnostics<CR>", bufopts)
	vim.keymap.set("n", "<leader>f", "<cmd>Lspsaga finder<CR>", bufopts)
	vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", bufopts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<leader>ac", function()
		require("actions-preview").code_actions()
	end, bufopts)
	vim.keymap.set("n", "<leader>bf", function()
		vim.lsp.buf.format()
	end, bufopts)

	vim.lsp.inlay_hint.enable(true)
end

require("actions-preview").setup({
	diff = {
		algorithm = "patience",
		ignore_whitespace = true,
	},
})

require("hover").setup({

	config = function()
		require("hover").setup({
			init = function()
				-- Require providers
				require("hover.providers.lsp")
				-- require('hover.providers.gh')
				-- require('hover.providers.gh_user')
				-- require('hover.providers.jira')
				-- require('hover.providers.dap')
				-- require('hover.providers.fold_preview')
				-- require('hover.providers.diagnostic')
				-- require('hover.providers.man')
				-- require('hover.providers.dictionary')
				require("hover.providers.highlight")
			end,
			preview_opts = {
				border = "double",
			},
			-- Whether the contents of a currently open hover window should be moved
			-- to a :h preview-window when pressing the hover keymap.
			preview_window = true,
			title = true,
			mouse_providers = {
				"LSP",
			},
			mouse_delay = 1000,
		})

		-- Setup keymaps
		vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
		vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
		vim.keymap.set("n", "<C-p>", function()
			require("hover").hover_switch("previous")
		end, { desc = "hover.nvim (previous source)" })
		vim.keymap.set("n", "<C-n>", function()
			require("hover").hover_switch("next")
		end, { desc = "hover.nvim (next source)" })

		-- Mouse support
		vim.keymap.set("n", "<MouseMove>", require("hover").hover_mouse, { desc = "hover.nvim (mouse)" })
		vim.o.mousemoveevent = true
	end,
})

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

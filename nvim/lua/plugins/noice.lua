return {
	"folke/noice.nvim",
	event = "VeryLazy",
	config = function()
		require("noice").setup({
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				progress = {
					enabled = true,
				},
				hover = {
					enabled = true,
					silent = false,
				},
				signature = {
					enabled = true,
					auto_open = {
						enabled = true,
						trigger = true,
						luasnip = true,
						throttle = 50,
					},
				},
				message = {
					enabled = true,
				},
				documentation = {
					view = "hover",
					opts = {
						lang = "markdown",
						replace = true,
						render = "plain",
						format = { "{message}" },
						win_options = { concealcursor = "n", conceallevel = 3 },
					},
				},
			},
			messages = {
				enabled = true,
				view = "notify",
				view_error = "notify",
				view_warn = "notify",
				view_history = "messages",
				view_search = "virtualtext",
			},
			notify = {
				enabled = true,
				view = "notify",
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = true,
			},
			views = {
				cmdline_popup = {
					border = {
						style = "rounded",
					},
				},
				popupmenu = {
					relative = "editor",
					border = {
						style = "rounded",
					},
				},
				hover = {
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					position = { row = 2, col = 2 },
					size = {
						max_width = 80,
						max_height = 20,
					},
					win_options = {
						winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
						wrap = true,
						linebreak = true,
					},
				},
				mini = {
					position = {
						row = -2,
						col = "100%",
					},
					size = {
						width = "auto",
						height = "auto",
					},
					border = {
						style = "rounded",
					},
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "msg_show",
						kind = "search_count",
					},
					opts = { skip = true },
				},
				{
					filter = {
						find = "No information available",
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "lsp",
						kind = "progress",
						cond = function(message)
							local client = vim.tbl_get(message.opts, "progress", "client")
							return client == "lua_ls"
						end,
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "lsp",
						kind = "progress",
						find = "code_action",
					},
					opts = { skip = true },
				},
				{
					filter = {
						error = true,
						min_height = 10,
					},
					view = "split",
				},
			},
		})

		-- Setup keymaps for LSP hover and diagnostics
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })
		vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "LSP Signature Help" })

		-- LSP hover scrolling
		vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
			if not require("noice.lsp").scroll(4) then
				return "<c-f>"
			end
		end, { silent = true, expr = true, desc = "Scroll forward in hover" })

		vim.keymap.set({ "n", "i", "s" }, "<c-b>", function()
			if not require("noice.lsp").scroll(-4) then
				return "<c-b>"
			end
		end, { silent = true, expr = true, desc = "Scroll backward in hover" })

		-- Show diagnostics in floating window
		vim.keymap.set("n", "<leader>d", function()
			vim.diagnostic.open_float(nil, {
				border = "rounded",
				source = "always",
				prefix = " ",
			})
		end, { desc = "Show Diagnostics" })

		-- Navigate diagnostics
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })

		-- Noice commands
		vim.keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Messages" })
		vim.keymap.set("n", "<leader>nh", "<cmd>NoiceHistory<CR>", { desc = "Noice History" })
		vim.keymap.set("n", "<leader>nl", "<cmd>NoiceLast<CR>", { desc = "Noice Last Message" })
		vim.keymap.set("n", "<leader>ne", "<cmd>NoiceErrors<CR>", { desc = "Noice Errors" })

		-- Configure LSP handlers for bordered windows
		local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
		function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
			opts = opts or {}
			opts.border = opts.border or "rounded"
			return orig_util_open_floating_preview(contents, syntax, opts, ...)
		end
	end,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"hrsh7th/nvim-cmp",
	},
}

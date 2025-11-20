return {

	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			require("dapui").setup()

			dap.adapters.gdb = {
				type = "executable",
				command = "gdb",
				args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
			}

			dap.configurations.c = {
				{
					name = "Launch",
					type = "gdb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopAtBeginningOfMainSubprogram = false,
				},
				{
					name = "Attach to gdbserver :1234",
					type = "gdb",
					request = "attach",
					target = "127.0.0.1:1234",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
					end,
					cwd = "${workspaceFolder}",
				},
			}

			-- Key mappings for nvim-dap
			vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>", { silent = true })
			vim.keymap.set("n", "<F5>", ":DapContinue<CR>", { silent = true })
			vim.keymap.set("n", "<F11>", ":DapStepInto<CR>", { silent = true })
			vim.keymap.set("n", "<F10>", ":DapStepOver<CR>", { silent = true })
			vim.keymap.set("n", "<F12>", ":DapStepOut<CR>", { silent = true })
			vim.keymap.set("n", "<leader>dt", ":DapTerminate<CR>", { silent = true })
			vim.keymap.set("n", "<leader>do", function()
				require("dapui").open()
			end, { silent = true })

			vim.keymap.set("n", "<leader>dc", function()
				require("dapui").close()
			end, { silent = true })

			vim.keymap.set("n", "<leader>dw", function()
				local word = vim.fn.expand("<cword>")
				require("dapui").elements.watches.add(word)
			end, { silent = true })
		end,
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
	},
}

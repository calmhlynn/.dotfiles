local dap = require("dap")
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
vim.keymap.set("n", "<C-b>", ":DapToggleBreakpoint<CR>", { silent = true })
vim.keymap.set("n", "<C-d>", ":DapContinue<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", ":DapStepInto<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", ":DapStepOver<CR>", { silent = true })
vim.keymap.set("n", "<C-h>", ":DapStepOut<CR>", { silent = true })
vim.keymap.set("n", "<C-q>", ":DapTerminate<CR>", { silent = true })
vim.keymap.set("n", "<C-o>", function()
	require("dapui").open()
end, { silent = true })

vim.keymap.set("n", "<C-c>", function()
	require("dapui").close()
end, { silent = true })

vim.keymap.set("n", "<C-e>", function()
	local word = vim.fn.expand("<cword>")
	require("dapui").elements.watches.add(word)
end, { silent = true })

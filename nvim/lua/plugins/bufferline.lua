require("bufferline").setup({
	options = {
		mode = "buffers",
		numbers = "ordinal",
		diagnostics = "nvim_lsp",
		custom_filter = function(buf)
			return vim.bo[buf].buftype ~= "terminal"
		end,
	},
})

vim.keymap.set("n", "<leader>n", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>p", "<cmd>bprev<cr>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>q", "<cmd>bp | bd #<cr>", { desc = "Close Buffer" })
vim.keymap.set("n", "<leader>b", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close Other Buffers" })

for i = 1, 9 do
	vim.keymap.set("n", "<leader>" .. i, function()
		require("bufferline").go_to(i, true)
	end, { desc = "Go to Buffer " .. i })
end

vim.keymap.set("n", "<leader>$", function()
	require("bufferline").go_to(-1, true)
end, { desc = "Go to Last Buffer" })

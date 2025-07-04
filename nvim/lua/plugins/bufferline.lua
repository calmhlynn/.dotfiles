return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		options = {
			mode = "buffers",
			numbers = "ordinal",
			diagnostics = "nvim_lsp",
			offsets = {
				filetype = "NvimTree",
				text = "File Explorer",
			},
		},
	},
	config = function()
		require("bufferline").setup(opts)
		vim.keymap.set("n", "<Leader>n", ":bnext<CR>", { silent = true })
		vim.keymap.set("n", "<Leader>p", ":bprev<CR>", { silent = true })
		vim.keymap.set("n", "<Leader>q", ":bp | bd #<CR>", { silent = true })

		vim.keymap.set("n", "<leader>1", function()
			require("bufferline").go_to(1, true)
		end, { silent = true })
		vim.keymap.set("n", "<leader>2", function()
			require("bufferline").go_to(2, true)
		end, { silent = true })
		vim.keymap.set("n", "<leader>3", function()
			require("bufferline").go_to(3, true)
		end, { silent = true })
		vim.keymap.set("n", "<leader>4", function()
			require("bufferline").go_to(4, true)
		end, { silent = true })
		vim.keymap.set("n", "<leader>5", function()
			require("bufferline").go_to(5, true)
		end, { silent = true })
		vim.keymap.set("n", "<leader>6", function()
			require("bufferline").go_to(6, true)
		end, { silent = true })
		vim.keymap.set("n", "<leader>7", function()
			require("bufferline").go_to(7, true)
		end, { silent = true })
		vim.keymap.set("n", "<leader>8", function()
			require("bufferline").go_to(8, true)
		end, { silent = true })
		vim.keymap.set("n", "<leader>9", function()
			require("bufferline").go_to(9, true)
		end, { silent = true })
		vim.keymap.set("n", "<leader>$", function()
			require("bufferline").go_to(-1, true)
		end, { silent = true })
	end,
}

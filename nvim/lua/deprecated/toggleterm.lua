return {

	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 20,
			auto_scroll = false,
			persist_size = false,
			persist_mode = false,
			-- direction = "float",
			highlights = {
				Normal = {
					link = "Normal",
				},
				NormalFloat = {
					link = "NormalFloat",
				},
				FloatBorder = {
					link = "FloatBorder",
				},
			},

			float_opts = {
				border = "rounded",
			},
		})

		vim.api.nvim_create_autocmd(
			"TermEnter",
			{ pattern = "term://*toggleterm#*", command = [[tnoremap <silent><Esc> <Cmd>exe v:count1 . "ToggleTerm"<CR>]] }
		)

		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = function(_)
				local get_ls = vim.tbl_filter(function(buf)
					return vim.api.nvim_buf_is_valid(buf) and string.find(vim.api.nvim_buf_get_name(buf), "toggleterm#") ~= nil
				end, vim.api.nvim_list_bufs())
				for _, buf in pairs(get_ls) do
					vim.api.nvim_buf_delete(buf, { force = true })
				end
			end,
		})
	end,
}

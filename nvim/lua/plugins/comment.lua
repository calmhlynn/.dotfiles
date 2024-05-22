require("Comment").setup({
	pre_hook = function()
		return vim.bo.commentstring
	end,
})

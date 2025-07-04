return {

	"numToStr/Comment.nvim",

	pre_hook = function()
		return vim.bo.commentstring
	end,
}

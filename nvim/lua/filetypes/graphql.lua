vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
	pattern = "graphql",
	command = "setlocal shiftwidth=2",
})

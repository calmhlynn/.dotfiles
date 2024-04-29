vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
	pattern = "prisma",
	command = "setlocal shiftwidth=2",
})

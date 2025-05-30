require("lspconfig").clangd.setup({
	cmd = { "clangd", "--background-index", "--clang-tidy" },
	filetypes = { "c", "cpp", "objc", "objcpp" },
	capabilities = {
		offsetEncoding = "utf-8",
	},
	on_attach = function(client, bufnr)
		LSP_ON_ATTACH(client, bufnr)
		-- Set indentation settings for the buffer
		vim.bo[bufnr].tabstop = 2
		vim.bo[bufnr].shiftwidth = 2
		vim.bo[bufnr].expandtab = true -- Use spaces instead of tabs
	end,
})

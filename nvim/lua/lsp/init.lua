-- Server configs live in lsp/*.lua and are discovered via 'runtimepath'.
vim.lsp.enable({ "clangd", "pyright", "eslint", "vtsls", "tailwindcss", "lua_ls" })

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

local lsp_float = { border = "rounded", focusable = true, max_width = 80, max_height = 20, silent = false, wrap = true }

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_float_keymaps", { clear = true }),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover(lsp_float)
		end, vim.tbl_extend("force", opts, { desc = "LSP Hover" }))
		vim.keymap.set("n", "gK", function()
			vim.lsp.buf.signature_help(lsp_float)
		end, vim.tbl_extend("force", opts, { desc = "LSP Signature Help" }))
	end,
})

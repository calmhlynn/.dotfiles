local function copy_file_ref()
	local filepath = vim.fn.expand("%:.")
	local ref = "@" .. filepath .. "#L" .. vim.fn.line(".")
	vim.fn.setreg("+", ref)
	vim.notify("Copied: " .. ref)
end

local function copy_file_ref_visual()
	local filepath = vim.fn.expand("%:.")
	local start_line = vim.fn.line("v")
	local end_line = vim.fn.line(".")
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end
	local ref
	if start_line == end_line then
		ref = "@" .. filepath .. "#L" .. start_line
	else
		ref = "@" .. filepath .. "#L" .. start_line .. "-" .. end_line
	end
	vim.fn.setreg("+", ref)
	vim.notify("Copied: " .. ref)
end

vim.keymap.set("n", "<leader>yr", copy_file_ref, { desc = "Copy file reference" })
vim.keymap.set("v", "<leader>yr", copy_file_ref_visual, { desc = "Copy file reference (visual)" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
	callback = function(ev)
		local bufnr = ev.buf

		vim.schedule(function()
			pcall(function()
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end)
		end)

		vim.keymap.set("n", "[[", "<C-o>", { buffer = bufnr, desc = "Go to Older Position in Jumplist" })
		vim.keymap.set("n", "]]", "<C-i>", { buffer = bufnr, desc = "Go to Newer Position in Jumplist" })

		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next Diagnostic" })
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Previous Diagnostic" })

		vim.keymap.set("n", "]e", function()
			vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
		end, { buffer = bufnr, desc = "Next Error" })
		vim.keymap.set("n", "[e", function()
			vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
		end, { buffer = bufnr, desc = "Previous Error" })

		vim.keymap.set("n", "]w", function()
			vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
		end, { buffer = bufnr, desc = "Next Warning" })
		vim.keymap.set("n", "[w", function()
			vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
		end, { buffer = bufnr, desc = "Previous Warning" })

		vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { buffer = bufnr, desc = "Show Diagnostic" })
	end,
})

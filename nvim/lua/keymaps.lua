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
			pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
			pcall(vim.lsp.semantic_tokens.enable, false, { bufnr = bufnr })
		end)

		vim.keymap.set("n", "[[", "<C-o>", { buffer = bufnr, desc = "Go to Older Position in Jumplist" })
		vim.keymap.set("n", "]]", "<C-i>", { buffer = bufnr, desc = "Go to Newer Position in Jumplist" })

		local S = vim.diagnostic.severity
		for _, m in ipairs({
			{ "]d", 1,  nil,      "Next Diagnostic" },
			{ "[d", -1, nil,      "Previous Diagnostic" },
			{ "]e", 1,  S.ERROR,  "Next Error" },
			{ "[e", -1, S.ERROR,  "Previous Error" },
			{ "]w", 1,  S.WARN,   "Next Warning" },
			{ "[w", -1, S.WARN,   "Previous Warning" },
		}) do
			vim.keymap.set("n", m[1], function()
				vim.diagnostic.jump({ count = m[2], severity = m[3] })
			end, { buffer = bufnr, desc = m[4] })
		end

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Goto Definition" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Goto Declaration" })
		vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Goto Implementation" })
		vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Goto Type Definition" })

		vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { buffer = bufnr, desc = "Show Diagnostic" })
		vim.keymap.set({ "n", "v" }, "<leader>ac", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
		vim.keymap.set("n", "<leader>D", function()
			if #vim.lsp.get_clients({ bufnr = bufnr, method = "workspace/diagnostic" }) > 0 then
				vim.lsp.buf.workspace_diagnostics()
				vim.defer_fn(function()
					vim.diagnostic.setqflist({ open = true })
				end, 200)
				return
			end

			vim.diagnostic.setqflist({ open = true })
		end, { buffer = bufnr, desc = "Workspace Diagnostics" })
	end,
})

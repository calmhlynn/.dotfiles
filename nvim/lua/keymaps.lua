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

		vim.keymap.set("n", "[[", "<C-o>", { buf = bufnr, desc = "Go to Older Position in Jumplist" })
		vim.keymap.set("n", "]]", "<C-i>", { buf = bufnr, desc = "Go to Newer Position in Jumplist" })

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
			end, { buf = bufnr, desc = m[4] })
		end

		vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { buf = bufnr, desc = "Show Diagnostic" })
	end,
})

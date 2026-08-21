return {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		"pyrightconfig.json",
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		".git",
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightOrganizeImports", function()
			client:request("workspace/executeCommand", {
				command = "pyright.organizeimports",
				arguments = { vim.uri_from_bufnr(bufnr) },
			}, nil, bufnr)
		end, { desc = "Organize Imports" })
	end,
}

return {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
	root_markers = {
		".clangd",
		".clang-tidy",
		".clang-format",
		"compile_commands.json",
		"compile_flags.txt",
		"configure.ac",
		".git",
	},
	get_language_id = function(_, ftype)
		return ({ objc = "objective-c", objcpp = "objective-cpp", cuda = "cuda-cpp" })[ftype] or ftype
	end,
	capabilities = {
		textDocument = { completion = { editsNearCursor = true } },
		offsetEncoding = { "utf-8", "utf-16" },
	},
	on_init = function(client, init_result)
		if init_result.offsetEncoding then
			client.offset_encoding = init_result.offsetEncoding
		end
	end,
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspClangdSwitchSourceHeader", function()
			local method = "textDocument/switchSourceHeader"
			if not client:supports_method(method) then
				vim.notify("method " .. method .. " is not supported")
				return
			end
			client:request(method, vim.lsp.util.make_text_document_params(bufnr), function(err, result)
				if err then
					error(tostring(err))
				end
				if result then
					vim.cmd.edit(vim.uri_to_fname(result))
				end
			end, bufnr)
		end, { desc = "Switch between source/header" })
	end,
}
